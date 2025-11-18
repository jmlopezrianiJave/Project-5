import time
import pandas as pd
from pythonosc import udp_client
from config import OSCConfig

def send_stats(clients, base_addr: str, values: pd.Series) -> None:
    mean_val = float(values.mean())
    std_val = float(values.std())
    min_val = float(values.min())
    max_val = float(values.max())

    for client in clients:
        client.send_message(f"{base_addr}/mean", mean_val)
        client.send_message(f"{base_addr}/std", std_val)
        client.send_message(f"{base_addr}/min", min_val)
        client.send_message(f"{base_addr}/max", max_val)

def main() -> None:
    osc_conf = OSCConfig(host="127.0.0.1", port=5005)

    client_pd = udp_client.SimpleUDPClient(osc_conf.host, osc_conf.port)
    client_processing = udp_client.SimpleUDPClient(osc_conf.host, 5006)

    clients = [client_pd, client_processing]

    df = pd.read_csv("data_sender/StudentsPerformance.csv")

    for i in range(len(df)):
        current = df.iloc[: i + 1]
        count = len(current)

        for c in clients:
            c.send_message("/stats/count", int(count))

        send_stats(clients, "/stats/math", current["math score"])
        send_stats(clients, "/stats/reading", current["reading score"])
        send_stats(clients, "/stats/writing", current["writing score"])

        time.sleep(1.0)

if __name__ == "__main__":
    main()
