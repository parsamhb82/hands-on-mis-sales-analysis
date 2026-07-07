#!/usr/bin/env python3

import sqlite3
import pandas as pd
import os
import argparse


def export_sqlite_to_csv(database_path, output_folder):
    os.makedirs(output_folder, exist_ok=True)

    conn = sqlite3.connect(database_path)

    # Get all tables
    tables = pd.read_sql_query(
        """
        SELECT name 
        FROM sqlite_master 
        WHERE type='table'
        ORDER BY name;
        """,
        conn
    )

    for table in tables["name"]:
        print(f"Exporting table: {table}")

        df = pd.read_sql_query(
            f"SELECT * FROM {table}",
            conn
        )

        output_file = os.path.join(
            output_folder,
            f"{table}.csv"
        )

        df.to_csv(
            output_file,
            index=False
        )

        print(
            f"Saved {len(df)} rows -> {output_file}"
        )

    conn.close()

    print("\nExport completed successfully.")


if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        description="Export SQLite database tables to CSV files"
    )

    parser.add_argument(
        "database",
        help="Path to SQLite database file"
    )

    parser.add_argument(
        "output",
        help="Folder where CSV files will be created"
    )

    args = parser.parse_args()

    export_sqlite_to_csv(
        args.database,
        args.output
    )