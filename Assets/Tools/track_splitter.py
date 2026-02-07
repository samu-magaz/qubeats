import subprocess
import sys
from pathlib import Path

# ======================
# CONFIG
# ======================

DEMUCS_MODEL = "htdemucs"

# ======================
# MAIN
# ======================

def split_song(audio_path: Path):
    print("Running Demucs...")
    subprocess.run(
        ["demucs", "-n", DEMUCS_MODEL, str(audio_path)],
        check=True
    )

    output_dir = Path("separated") / DEMUCS_MODEL / audio_path.stem

    if not output_dir.exists():
        raise RuntimeError("Demucs output not found.")

    print("Stems created:")
    for stem in output_dir.iterdir():
        print(" -", stem)

    return output_dir

# ======================
# ENTRY POINT
# ======================

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python split_stems.py <song.wav|mp3>")
        sys.exit(1)

    audio_file = Path(sys.argv[1])

    if not audio_file.exists():
        print("Audio file not found.")
        sys.exit(1)

    split_song(audio_file)
