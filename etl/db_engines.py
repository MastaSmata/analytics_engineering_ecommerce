from sqlalchemy import create_engine
from google.cloud import bigquery

import os
from dotenv import load_dotenv

load_dotenv()


def require(name):
    value = os.getenv(name)
    if not value:
        raise EnvironmentError(f"Missing env var: {name}")
    return value


def require_port(name, default):
    value = os.getenv(name, default)
    if not value:
        raise EnvironmentError(f"Missing env var: {name}")
    return value


# ---------------- POSTGRES ----------------

POSTGRES_USER = require("POSTGRES_USER")
POSTGRES_PASSWORD = require("POSTGRES_PASSWORD")
POSTGRES_HOST = require("POSTGRES_HOST")
POSTGRES_PORT = require_port("POSTGRES_PORT", "5432")
POSTGRES_DB = require("POSTGRES_NAME")

source_engine = create_engine(
    f"postgresql+psycopg2://{POSTGRES_USER}:{POSTGRES_PASSWORD}"
    f"@{POSTGRES_HOST}:{POSTGRES_PORT}/{POSTGRES_DB}"
)


# ---------------- BIGQUERY ----------------

BIGQUERY_PROJECT = require("BIGQUERY_PROJECT")
BIGQUERY_DATASET = require("BIGQUERY_DATASET")
big_db = f"{BIGQUERY_PROJECT}.{BIGQUERY_DATASET}"

dest_engine = bigquery.Client(project=BIGQUERY_PROJECT)

print("DB connections initialized")
print("POSTGRES:", POSTGRES_HOST, POSTGRES_PORT, POSTGRES_DB)
print("BIGQUERY:", BIGQUERY_PROJECT, BIGQUERY_DATASET)
