#!/usr/bin/env python3
"""Build the opencode attention sound pack.

opencode's TUI audio engine (sound-play -> afplay on macOS) decodes MP3 only, so
every file here is written as MP3. Everything is synthesised: no speech, just
short musical motifs, one per event, so they stay distinguishable by ear.

Each event gets a distinct contour and timbre:

    permission     urgent repeated rising third, bright + insistent
    question       single questioning leap up, then a lift
    done           bright ascending major arpeggio
    error          two descending sour buzzes, harsh square-ish timbre
    subagent_done  one soft bell partial
    default        two neutral blips
"""

import json
import math
import os
import struct
import subprocess
import sys
import tempfile
import wave

SR = 44100
OUT = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "sounds")


# --- synthesis primitives -----------------------------------------------------


def silence(seconds):
    return [0.0] * int(SR * seconds)


def tone(freq, seconds, amp=1.0, harmonics=(1.0, 0.3, 0.12, 0.05), attack=0.003, decay=None):
    """Additive sine with a few partials, fast attack, exponential tail."""
    n = int(SR * seconds)
    decay = seconds / 3 if decay is None else decay
    out = []
    for i in range(n):
        t = i / SR
        env = min(1.0, t / attack) if attack > 0 else 1.0
        env *= math.exp(-t / decay)
        v = sum(h * math.sin(2 * math.pi * freq * (k + 1) * t) for k, h in enumerate(harmonics))
        out.append(amp * env * v)
    return out


def bell(freq, seconds, amp=1.0):
    """Inharmonic struck-bell partials with long decay."""
    partials = ((1.0, 1.0), (2.0, 0.5), (2.76, 0.35), (5.4, 0.18), (8.9, 0.08))
    n = int(SR * seconds)
    out = []
    for i in range(n):
        t = i / SR
        env = min(1.0, t / 0.002) * math.exp(-t / (seconds / 4))
        v = sum(a * math.sin(2 * math.pi * freq * r * t) for r, a in partials)
        out.append(amp * env * v)
    return out


def glide(f0, f1, seconds, amp=1.0, odd=3, attack=0.004):
    """Exponential pitch sweep with a buzzy (odd-harmonic) spectrum."""
    n = int(SR * seconds)
    out = []
    phase = 0.0
    for i in range(n):
        t = i / SR
        f = f0 * math.pow(f1 / f0, i / n)
        phase += 2 * math.pi * f / SR
        env = min(1.0, t / attack) * math.exp(-t / (seconds / 2.2))
        v = sum(math.sin(phase * (2 * k + 1)) / (k + 1) for k in range(odd))
        out.append(amp * env * v)
    return out


def cat(*parts):
    out = []
    for p in parts:
        out.extend(p)
    return out


# --- io ----------------------------------------------------------------------


def normalize(samples, peak=0.99):
    hi = max((abs(s) for s in samples), default=0.0)
    if hi == 0:
        return samples
    return [s * (peak / hi) for s in samples]


def write_wav(samples, path):
    clipped = [max(-1.0, min(1.0, s)) for s in samples]
    with wave.open(path, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(struct.pack("<%dh" % len(clipped), *[int(s * 32767) for s in clipped]))


def trim(samples, thresh=1e-4, pad=0.02):
    """Drop trailing near-silence, keep a short pad so the tail is not clipped."""
    hi = 0
    for i in range(len(samples) - 1, -1, -1):
        if abs(samples[i]) > thresh:
            hi = i
            break
    return samples[:hi + int(SR * pad)]


def encode(samples, name, target_lufs=-11.0, makeup=0.0):
    """Render to MP3, normalised to a target integrated loudness.

    Peak-normalising short percussive tones leaves them quiet on average; the
    point of a notification is to be heard, so normalise to an LUFS target and
    let loudnorm hold true peak at -1 dBTP. `makeup` adds extra dB for peaky
    material (bells) that linear mode will not push, behind a limiter.
    """
    os.makedirs(OUT, exist_ok=True)
    with tempfile.TemporaryDirectory() as td:
        raw = os.path.join(td, "s.wav")
        pre = os.path.join(td, "p.wav")
        mp3 = os.path.join(OUT, name + ".mp3")
        write_wav(normalize(trim(samples)), raw)

        # pass 1: measure
        probe = subprocess.run(
            ["ffmpeg", "-hide_banner", "-nostats", "-i", raw, "-af", "loudnorm=print_format=json",
             "-f", "null", "-"],
            capture_output=True, text=True,
        ).stderr
        m = json.loads(probe[probe.rindex("{"):probe.rindex("}") + 1])

        filt = f"loudnorm=I={target_lufs}:TP=-1.0:LRA=11"
        if m.get("input_i", "-inf") != "-inf":
            filt += (
                f":measured_I={m['input_i']}:measured_TP={m['input_tp']}"
                f":measured_LRA={m['input_lra']}:measured_thresh={m['input_thresh']}"
                f":offset={m['target_offset']}:linear=true"
            )
        if makeup:
            filt += f",volume={makeup}dB,alimiter=limit=0.97:level=disabled"
        subprocess.run(
            ["ffmpeg", "-hide_banner", "-loglevel", "error", "-i", raw, "-af", filt,
             "-ar", str(SR), "-ac", "1", "-y", pre],
            check=True,
        )
        subprocess.run(
            ["ffmpeg", "-hide_banner", "-loglevel", "error", "-i", pre,
             "-codec:a", "libmp3lame", "-b:a", "160k", "-ar", str(SR), "-y", mp3],
            check=True,
        )
    kb = os.path.getsize(os.path.join(OUT, name + ".mp3")) / 1024
    print(f"  {name}.mp3  {kb:.0f} KB  ({target_lufs} LUFS)")


# --- the pack ----------------------------------------------------------------

N = "C5 E5 G5 C6"  # pitch helper, in Hz
C5, D5, E5, F5, G5, A5, B5 = 523.25, 587.33, 659.25, 698.46, 783.99, 880.0, 987.77
C6, D6, E6, F6, G6 = 1046.5, 1174.7, 1318.5, 1396.9, 1568.0


def main():
    # permission: insistent triple rise, held a beat longer than question
    rise = cat(tone(C6, 0.11, 1.0, decay=0.07), tone(E6, 0.16, 1.0, decay=0.11))
    encode(cat(rise, silence(0.10), rise, silence(0.10), rise, silence(0.18)), "permission", makeup=2.0)

    # question: one questioning leap up, then an answering lift
    encode(
        cat(
            tone(G5, 0.15, 0.9, decay=0.11),
            tone(C6, 0.15, 0.9, decay=0.11),
            silence(0.04),
            tone(E6, 0.34, 1.0, decay=0.30),
            silence(0.16),
        ),
        "question",
        makeup=3.5,
    )

    # done: bright ascending major arpeggio
    arp = cat(*(tone(f, d, 0.95, decay=d / 2.6) for f, d in
                ((C5, 0.10), (E5, 0.10), (G5, 0.10), (C6, 0.46))))
    encode(cat(arp, silence(0.24)), "done", makeup=2.0)

    # error: two descending sour buzzes
    buzz = cat(glide(F5, C5, 0.26, 1.0, odd=5), silence(0.06))
    encode(cat(buzz, buzz, silence(0.16)), "error", makeup=1.0)

    # subagent_done: two tight bell strikes (a long single decay reads as too soft)
    hit = bell(G5, 0.30, 1.0)
    encode(cat(hit, silence(0.05), tone(G5, 0.22, 0.85, decay=0.09)), "subagent_done", makeup=6.0)

    # default: two neutral blips
    blip = tone(A5, 0.09, 0.9, decay=0.06)
    encode(cat(blip, silence(0.07), blip, silence(0.10)), "default")

    print(f"\nWrote pack to {OUT}")


if __name__ == "__main__":
    sys.exit(main())
