# Endpoint AI Guardian

Endpoint telemetry and behavioral analysis platform designed to detect suspicious AI agents and local AI runtimes.

## Architecture

agent-macos → macOS telemetry collector
agent-windows → Windows telemetry collector
backend-api → telemetry ingestion service
processor → scoring + AI runtime detection
docs → architecture documentation