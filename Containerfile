FROM python:3.12-slim

ARG BRANCH=jjee-adaptations
ARG REPOSITORY_URL=https://github.com/humlab/jjee_notebooks.git

ENV PATH=/opt/venv/bin:$PATH \
    PYTHONUNBUFFERED=1 \
    UV_PROJECT_ENVIRONMENT=/opt/venv \
    UV_NO_CACHE=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates git \
    && rm -rf /var/lib/apt/lists/*

RUN python -m pip install --no-cache-dir uv

WORKDIR /workspace

RUN git clone --depth 1 --branch "${BRANCH}" "${REPOSITORY_URL}" . \
    && uv sync --locked --no-dev --no-install-project

EXPOSE 8888

CMD ["jupyter", "lab", ".", "--ip=0.0.0.0", "--port=8888", "--no-browser"]
