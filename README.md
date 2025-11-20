# Project 5 – Audio-Visual Data Explorer  
_Final project by Jose Miguel Lopez & Juan Sebastián Garizao_

This project is a **real-time data-driven audio-visual system**. A Python script streams rolling statistics from a dataset using **OSC**, and both **Pure Data** (audio) and **Processing** (visuals) react dynamically:

- Python (`db_stats_stream.py`) reads the dataset and sends statistical values via OSC.
- Pure Data (`puredata_audio/seqMain.pd` or `pd/seqMain.pd`, depending on your folder name) transforms those values into synthesis and sequencing changes.
- Processing (`processing_visualizer/StatsVisualizer.pde` or `StatsVisualizer.pde`) updates shapes, movement, and color based on incoming data.

## 🔧 How the System Works

### 1. Python – Streaming Statistics

File: `db_stats_stream.py`

1. Loads `data_sender/StudentsPerformance.csv` using Pandas.  
2. Iterates through the dataset gradually (e.g., one row per time step).  
3. Computes real-time statistics for subjects such as math, reading, and writing:
   - mean  
   - standard deviation (std)  
   - minimum  
   - maximum  
4. Sends these values every cycle via OSC to:
   - Pure Data (default port: 5005)  
   - Processing (default port: 5006)
5. Sends `/stats/count`, representing the number of processed rows so far.

As more rows are included, the statistics evolve, and so do the audio and visuals.

---

### 2. Pure Data – Audio Layer

File: `puredata_audio/seqMain.pd` (or `pd/seqMain.pd`)

- Receives OSC messages with addresses like:
  - `/stats/math/mean`
  - `/stats/math/std`
  - `/stats/reading/mean`
  - `/stats/writing/mean`
  - `/stats/count`
- Routes these addresses and maps the numerical values to synthesis and sequencing parameters:
  - Pitch and transposition
  - Filter cutoff and resonance
  - Distortion or other effects
  - Sequencer randomness, density, and triggering

The sonic landscape continuously changes as the incoming statistics change.

---

### 3. Processing – Visual Layer

File: `StatsVisualizer.pde` or `processing_visualizer/StatsVisualizer.pde`

- Uses the oscP5 library to receive OSC messages on its configured UDP port (default 5006).
- Reads the same statistics sent to Pd and maps them to visual parameters, for example:
  - Subject means → background color or color channels
  - Standard deviations → size, jitter, stroke weight, or deformation
  - Min/max values → position ranges or radius ranges
  - `/stats/count` → complexity, number of elements, or animation speed

Each update from Python produces a noticeable change in the visual output, giving a real-time “data art” representation of the dataset.

---

## 📦 Requirements

### Python

- Python 3.9 or newer
- Dependencies listed in `requirements.txt`

Example installation:

    pip install -r requirements.txt

Ensure that `data_sender/StudentsPerformance.csv` exists and that the path in `db_stats_stream.py` matches the actual location.

---

### Processing

- Processing 4.x (or latest stable)
- Library: oscP5 (install via Sketch → Import Library → Add Library… → search for “oscP5”)

---

### Pure Data

- Pure Data Vanilla (0.50 or newer)
- Open `seqMain.pd` from the appropriate folder and enable DSP

---

## ⚙️ OSC Configuration

Typical default configuration (either in `db_stats_stream.py` or `config.py`):

- Host: 127.0.0.1 (localhost)
- Ports:
  - 5005 → Pure Data
  - 5006 → Processing

Make sure:

- The Pd patch listens on the same port that Python uses for Pd (e.g., via `[udpreceive 5005]`).
- The Processing sketch instantiates oscP5 with the same port that Python uses for Processing (e.g., `new OscP5(this, 5006);`).

If Pd or Processing runs on a different machine, change the host IP in the Python configuration accordingly.

---

## 🚀 Running the System


1. Start Pure Data (audio)
   - Open `puredata_audio/seqMain.pd` or `pd/seqMain.pd`.
   - Verify that the `[udpreceive]` object is using the Pd port (default 5005).
   - Turn DSP ON.

2. Start Processing (visuals)
   - Open `StatsVisualizer.pde` or `processing_visualizer/StatsVisualizer.pde`.
   - Check that oscP5 is created with the Processing port (default 5006).
   - Run the sketch.

3. Start the Python streamer

    3.1 python -m venv .venv
    3.2 .venv\Scripts\activate
    3.3 pip install -r requirements.txt
   - From the project root:

         python data_sender\db_stats_stream.py

4. As the script iterates over the dataset:
   - Audio in Pure Data changes in rhythm, timbre, pitch, and effects.
   - Visuals in Processing change in color, shapes, motion, and complexity.

---

## 📄 Credits

Created by:

- José Miguel Lopez  
- Juan Sebastián Garizao  

Technologies used:

- Python, Pandas, python-osc  
- Processing, oscP5  
- Pure Data (Pd)

Youtube link: https://youtu.be/FclpTTkJVKA
