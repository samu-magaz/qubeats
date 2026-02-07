import librosa
import numpy as np
import json
import sys
from pathlib import Path

# ======================
# CONFIG
# ======================

LANES = 3
SUBDIVISIONS = 8          # 2 = 8th notes
MIN_FREQ = 80.0
MAX_FREQ = 1200.0
MIN_NOTE_GAP = 0.1
HOP_LENGTH = 512

# ======================
# UTILS
# ======================

def quantize(time, grid):
    return grid[np.argmin(np.abs(grid - time))]

def freq_to_lane(freq):
    freq = np.clip(freq, MIN_FREQ, MAX_FREQ)
    norm = (freq - MIN_FREQ) / (MAX_FREQ - MIN_FREQ)
    return int(norm * (LANES - 1))

# ======================
# MAIN
# ======================

def generate_chart(stem_path: Path, out_path="chart.json"):
    print(f"Loading stem: {stem_path}")
    y, sr = librosa.load(stem_path, sr=None, mono=True)

    # ----------------------
    # Beat tracking
    # ----------------------
    print("Detecting tempo...")
    tempo, beat_frames = librosa.beat.beat_track(y=y, sr=sr)
    beat_times = librosa.frames_to_time(beat_frames, sr=sr)

    if len(beat_times) < 2:
        raise RuntimeError("Beat detection failed.")

    print(f"BPM: {tempo}")

    # ----------------------
    # Beat grid
    # ----------------------
    beat_interval = np.diff(beat_times).mean()
    grid_times = []

    for beat in beat_times:
        for i in range(SUBDIVISIONS):
            grid_times.append(beat + i * beat_interval / SUBDIVISIONS)

    grid_times = np.array(grid_times)

    # ----------------------
    # Onset detection
    # ----------------------
    print("Detecting onsets...")
    onset_frames = librosa.onset.onset_detect(
        y=y,
        sr=sr,
        backtrack=True,
        delta=0.2
    )

    onset_times = librosa.frames_to_time(onset_frames, sr=sr)

    quantized_onsets = np.unique([
        quantize(t, grid_times) for t in onset_times
    ])

    print(f"Onsets: {len(quantized_onsets)}")

    # ----------------------
    # Frequency analysis (CQT)
    # ----------------------
    print("Computing CQT...")
    cqt = np.abs(librosa.cqt(
        y,
        sr=sr,
        hop_length=HOP_LENGTH
    ))

    freqs = librosa.cqt_frequencies(
        cqt.shape[0],
        fmin=librosa.note_to_hz("C2")
    )

    times = librosa.frames_to_time(
        np.arange(cqt.shape[1]),
        sr=sr,
        hop_length=HOP_LENGTH
    )

    def dominant_frequency(time):
        frame = np.argmin(np.abs(times - time))
        return freqs[np.argmax(cqt[:, frame])]

    # ----------------------
    # Build chart
    # ----------------------
    print("Building chart...")
    notes = []
    last_time = -999.0

    for t in quantized_onsets:
        if t - last_time < MIN_NOTE_GAP:
            continue

        freq = dominant_frequency(t)
        lane = freq_to_lane(freq)

        notes.append({
            "time": round(float(t), 4),
            "lane": lane,
            "length": 0.0
        })

        last_time = t

    chart = {
        "bpm": round(float(tempo), 2),
        "offset": round(float(beat_times[0]), 4),
        "lanes": LANES,
        "instrument": "guitar",
        "notes": notes
    }

    with open(out_path, "w") as f:
        json.dump(chart, f, indent=2)

    print(f"Chart saved to {out_path}")

# ======================
# ENTRY POINT
# ======================

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python generate_chart.py <guitar_stem.wav>")
        sys.exit(1)

    stem_file = Path(sys.argv[1])

    if not stem_file.exists():
        print("Stem file not found.")
        sys.exit(1)

    generate_chart(stem_file)
