from dataclasses import dataclass
from typing import Tuple

@dataclass
class OSCConfig:
    host: str = "127.0.0.1"
    port: int = 5005