from google.cloud import bigquery
from logger import logger
from db_engines import big_db


def normalize_columns(df):
    """
    Standardizes column names to ensure compatibility with SQL databases.
    """

    # Remove extra spaces, convert to lowercase, and replace
    # spaces/hyphens with underscores for SQL-safe naming
    df.columns = (
        df.columns.str.strip()
        .str.lower()
        .str.replace(" ", "_", regex=False)
        .str.replace("-", "_", regex=False)
    )

    return df


def load(df, table_name, engine):
    if df.empty:
        return

    df = normalize_columns(df)

    table_id = f"{big_db}.{table_name}"

    job_config = bigquery.LoadJobConfig(
        write_disposition="WRITE_APPEND"
    )

    engine.load_table_from_dataframe(
        df,
        table_id,
        job_config=job_config,
    ).result()

    logger.info(f"Loaded {len(df)} rows into {table_name}")