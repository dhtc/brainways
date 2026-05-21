FROM python:3.12 AS base
FROM base AS build

RUN pip install --no-cache-dir uv
RUN uv pip install --system --no-cache brainways PyQt5
RUN brainways ui
