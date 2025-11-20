## 1. Concept and data flow

1. **Dataset → Statistics (Python)**  
   The dataset `StudentsPerformance.csv` contains students’ scores in **math**, **reading** and **writing**.  
   The Python script:

   - Loads the CSV.
   - Iterates row by row.
   - At each step `i`, it takes all rows from `0` to `i` (a cumulative subset).
   - For that subset, it computes:

     - `count` of rows
     - `mean`, `std`, `min`, `max` for:
       - `math score`
       - `reading score`
       - `writing score`

   - Sends all those values as OSC messages every few seconds to:
     - **Pure Data** on port **5005**
     - **Processing** on port **5006**

2. **Statistics → Sound (Pure Data)**  
   The Pd patch `seqMain.pd` listens on port **5005** and uses the incoming OSC messages under the `/stats/...` namespace to control:

   - Activation of drums (kick, snare, hihat).
   - Bass note selection and transposition.
   - Tempo (BPM) of the sequencer.
   - Individual instrument volumes and master volume.
   - Distortion level and on/off.
   - A sensitivity mechanism that keeps changes perceptible even when the data stabilizes.

   As the cumulative statistics evolve, the groove becomes more or less dense, changes pitch, varies in tempo and turns effects on/off.

3. **Statistics → Visuals (Processing)**  
   The Processing sketch `StatsVisualizer.pde` listens on port **5006** with `oscP5` and receives the same messages:

   - `/stats/count`
   - `/stats/math/mean`, `/std`, `/min`, `/max`
   - `/stats/reading/mean`, `/std`, `/min`, `/max`
   - `/stats/writing/mean`, `/std`, `/min`, `/max`

   These values are mapped to:

   - **Colours:** means of each subject influence the background and object colours.
   - **Sizes / amount of shapes:** related to `count`, `max` and other aggregated values.
   - **Speed and jitter:** related to standard deviations (more spread → more movement).
   - **Scene resets:** when new values arrive, the visual state is reset so changes are clearly visible instead of slowly drifting.

   The result is a real-time visual performance that is synchronized with the musical changes happening in Pd.

---
Youtube link: https://youtu.be/FclpTTkJVKA
