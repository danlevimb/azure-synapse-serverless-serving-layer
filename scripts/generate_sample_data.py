"""
Generate controlled synthetic retail sample data for the
azure-synapse-serverless-serving-layer project.

The script creates small curated datasets intended to be uploaded to
Azure Data Lake Storage Gen2 and exposed through Azure Synapse Serverless SQL.

Generated logical layout:

sample_data/generated/
  curated/retail/customers/customers.parquet
  curated/retail/products/products.parquet
  curated/retail/orders/orders.parquet
  curated/retail/order_items/order_items.parquet
  csv/customers.csv
  csv/products.csv
  csv/orders.csv
  csv/order_items.csv

Requirements:
  pip install pandas pyarrow

Usage:
  python scripts/generate_sample_data.py
  python scripts/generate_sample_data.py --output-dir sample_data/generated
"""

from __future__ import annotations

import argparse
import shutil
from collections import Counter, defaultdict
from datetime import date, datetime
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path
from typing import Any

try:
    import pandas as pd
except ImportError as exc:  # pragma: no cover - user environment validation
    raise SystemExit(
        "Missing dependency: pandas. Install it with: pip install pandas pyarrow"
    ) from exc

try:
    import pyarrow as pa
    import pyarrow.parquet as pq
except ImportError as exc:  # pragma: no cover - user environment validation
    raise SystemExit(
        "Missing dependency: pyarrow. Install it with: pip install pandas pyarrow"
    ) from exc

PROJECT_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_OUTPUT_DIR = PROJECT_ROOT / "sample_data" / "generated"
BASE_TS = datetime(2026, 6, 15, 10, 0, 0)
MONEY_SCALE = Decimal("0.01")


def money(value: str | Decimal) -> Decimal:
    """Return a Decimal rounded to cents."""
    return Decimal(value).quantize(MONEY_SCALE, rounding=ROUND_HALF_UP)


def duplicate_count(values: list[Any]) -> int:
    """Count duplicate occurrences beyond the first occurrence."""
    counts = Counter(values)
    return sum(count - 1 for count in counts.values() if count > 1)


def clean_directory(path: Path) -> None:
    """Delete and recreate a generated output directory."""
    if path.exists():
        shutil.rmtree(path)
    path.mkdir(parents=True, exist_ok=True)


def write_dataset(
    *,
    dataset_name: str,
    records: list[dict[str, Any]],
    schema: pa.Schema,
    output_dir: Path,
) -> None:
    """Write one dataset as Parquet and CSV."""
    parquet_dir = output_dir / "curated" / "retail" / dataset_name
    csv_dir = output_dir / "csv"

    parquet_dir.mkdir(parents=True, exist_ok=True)
    csv_dir.mkdir(parents=True, exist_ok=True)

    table = pa.Table.from_pylist(records, schema=schema)
    pq.write_table(
        table,
        parquet_dir / f"{dataset_name}.parquet",
        compression="snappy",
        version="2.6",
    )

    # CSV files are included as human-readable companions.
    # Synapse MVP querying should use the Parquet files.
    pd.DataFrame(records).to_csv(csv_dir / f"{dataset_name}.csv", index=False)


def build_customers() -> list[dict[str, Any]]:
    return [
        {
            "customer_id": 1,
            "customer_name": "Northwind Retail Co.",
            "email": "contact@northwind-retail.example",
            "city": "Saltillo",
            "state_code": "COA",
            "customer_segment": "Corporate",
            "created_at": BASE_TS,
            "updated_at": BASE_TS,
        },
        {
            "customer_id": 2,
            "customer_name": "Sierra Bikes",
            "email": "ops@sierra-bikes.example",
            "city": "Monterrey",
            "state_code": "NL",
            "customer_segment": "Small Business",
            "created_at": BASE_TS,
            "updated_at": BASE_TS,
        },
        {
            "customer_id": 3,
            "customer_name": "Laguna Home Goods",
            "email": "sales@laguna-home.example",
            "city": "Torreon",
            "state_code": "COA",
            "customer_segment": "Consumer",
            "created_at": BASE_TS,
            "updated_at": BASE_TS,
        },
        {
            "customer_id": 4,
            "customer_name": "Capital Market MX",
            "email": "analytics@capital-market.example",
            "city": "Mexico City",
            "state_code": "CDMX",
            "customer_segment": "Corporate",
            "created_at": BASE_TS,
            "updated_at": BASE_TS,
        },
        {
            "customer_id": 5,
            "customer_name": "Pacific Office Supply",
            "email": "orders@pacific-office.example",
            "city": "Guadalajara",
            "state_code": "JAL",
            "customer_segment": "Small Business",
            "created_at": BASE_TS,
            "updated_at": BASE_TS,
        },
        {
            "customer_id": 6,
            "customer_name": "Desert Tech Store",
            "email": "hello@desert-tech.example",
            "city": "Hermosillo",
            "state_code": "SON",
            "customer_segment": "Consumer",
            "created_at": BASE_TS,
            "updated_at": BASE_TS,
        },
        {
            "customer_id": 7,
            "customer_name": "Bajio Digital Labs",
            "email": "team@bajio-digital.example",
            "city": "Queretaro",
            "state_code": "QRO",
            "customer_segment": "Corporate",
            "created_at": BASE_TS,
            "updated_at": BASE_TS,
        },
        {
            "customer_id": 8,
            "customer_name": "Maya Commerce Group",
            "email": "admin@maya-commerce.example",
            "city": "Merida",
            "state_code": "YUC",
            "customer_segment": "Small Business",
            "created_at": BASE_TS,
            "updated_at": BASE_TS,
        },
        {
            "customer_id": 9,
            "customer_name": "Central Learning Supplies",
            "email": "support@central-learning.example",
            "city": "Puebla",
            "state_code": "PUE",
            "customer_segment": "Education",
            "created_at": BASE_TS,
            "updated_at": BASE_TS,
        },
        {
            "customer_id": 10,
            "customer_name": "Frontier Hardware Hub",
            "email": "warehouse@frontier-hardware.example",
            "city": "Tijuana",
            "state_code": "BCN",
            "customer_segment": "Corporate",
            "created_at": BASE_TS,
            "updated_at": BASE_TS,
        },
    ]


def build_products() -> list[dict[str, Any]]:
    return [
        {
            "product_id": 101,
            "product_name": "Mechanical Keyboard",
            "category": "Accessories",
            "unit_price": money("89.90"),
            "is_active": True,
            "created_at": BASE_TS,
            "updated_at": BASE_TS,
        },
        {
            "product_id": 102,
            "product_name": "Wireless Mouse",
            "category": "Accessories",
            "unit_price": money("29.90"),
            "is_active": True,
            "created_at": BASE_TS,
            "updated_at": BASE_TS,
        },
        {
            "product_id": 103,
            "product_name": "27-inch Monitor",
            "category": "Displays",
            "unit_price": money("249.00"),
            "is_active": True,
            "created_at": BASE_TS,
            "updated_at": BASE_TS,
        },
        {
            "product_id": 104,
            "product_name": "USB-C Docking Station",
            "category": "Accessories",
            "unit_price": money("119.00"),
            "is_active": True,
            "created_at": BASE_TS,
            "updated_at": BASE_TS,
        },
        {
            "product_id": 105,
            "product_name": "Noise Cancelling Headset",
            "category": "Audio",
            "unit_price": money("159.50"),
            "is_active": True,
            "created_at": BASE_TS,
            "updated_at": BASE_TS,
        },
        {
            "product_id": 106,
            "product_name": "Laptop Stand",
            "category": "Accessories",
            "unit_price": money("49.90"),
            "is_active": True,
            "created_at": BASE_TS,
            "updated_at": BASE_TS,
        },
        {
            "product_id": 107,
            "product_name": "Portable SSD 1TB",
            "category": "Storage",
            "unit_price": money("129.00"),
            "is_active": True,
            "created_at": BASE_TS,
            "updated_at": BASE_TS,
        },
        {
            "product_id": 108,
            "product_name": "Webcam 1080p",
            "category": "Video",
            "unit_price": money("69.90"),
            "is_active": True,
            "created_at": BASE_TS,
            "updated_at": BASE_TS,
        },
        {
            "product_id": 109,
            "product_name": "Ergonomic Chair",
            "category": "Office",
            "unit_price": money("299.00"),
            "is_active": True,
            "created_at": BASE_TS,
            "updated_at": BASE_TS,
        },
        {
            "product_id": 110,
            "product_name": "Desk Lamp Pro",
            "category": "Office",
            "unit_price": money("39.90"),
            "is_active": False,
            "created_at": BASE_TS,
            "updated_at": BASE_TS,
        },
    ]


def build_order_items() -> list[dict[str, Any]]:
    raw_items = [
        (1, 1001, 101, 2, "89.90"),
        (2, 1001, 102, 3, "29.90"),
        (3, 1001, 106, 2, "49.90"),
        (4, 1002, 103, 1, "249.00"),
        (5, 1003, 104, 1, "119.00"),
        (6, 1004, 101, 1, "89.90"),
        (7, 1005, 105, 2, "159.50"),
        (8, 1005, 108, 1, "69.90"),
        (9, 1006, 107, 1, "129.00"),
        (10, 1006, 102, 2, "29.90"),
        (11, 1007, 109, 1, "299.00"),
        (12, 1007, 110, 2, "39.90"),
        (13, 1008, 103, 2, "249.00"),
        (14, 1009, 106, 4, "49.90"),
        (15, 1009, 102, 4, "29.90"),
        (16, 1010, 105, 1, "159.50"),
        (17, 1010, 101, 1, "89.90"),
        (18, 1011, 107, 2, "129.00"),
        (19, 1012, 108, 3, "69.90"),
        (20, 1012, 102, 1, "29.90"),
        (21, 1013, 104, 2, "119.00"),
        (22, 1013, 106, 1, "49.90"),
        (23, 1014, 109, 1, "299.00"),
        (24, 1015, 103, 1, "249.00"),
        (25, 1015, 107, 1, "129.00"),
        (26, 1016, 101, 3, "89.90"),
        (27, 1016, 102, 3, "29.90"),
        (28, 1017, 105, 1, "159.50"),
        (29, 1017, 108, 2, "69.90"),
        (30, 1018, 106, 2, "49.90"),
        (31, 1018, 110, 1, "39.90"),
        (32, 1019, 107, 1, "129.00"),
        (33, 1019, 104, 1, "119.00"),
        (34, 1020, 109, 1, "299.00"),
        (35, 1020, 103, 1, "249.00"),
        (36, 1021, 102, 5, "29.90"),
        (37, 1021, 106, 2, "49.90"),
        (38, 1022, 105, 2, "159.50"),
        (39, 1022, 107, 1, "129.00"),
        (40, 1023, 108, 1, "69.90"),
        (41, 1023, 101, 1, "89.90"),
        (42, 1024, 104, 1, "119.00"),
        (43, 1024, 110, 2, "39.90"),
    ]

    records: list[dict[str, Any]] = []
    for order_item_id, order_id, product_id, quantity, unit_price_value in raw_items:
        unit_price = money(unit_price_value)
        line_total = money(unit_price * Decimal(quantity))
        records.append(
            {
                "order_item_id": order_item_id,
                "order_id": order_id,
                "product_id": product_id,
                "quantity": quantity,
                "unit_price": unit_price,
                "line_total": line_total,
                "created_at": BASE_TS,
                "updated_at": BASE_TS,
            }
        )
    return records


def build_orders(order_items: list[dict[str, Any]]) -> list[dict[str, Any]]:
    totals_by_order: defaultdict[int, Decimal] = defaultdict(lambda: money("0.00"))
    for item in order_items:
        totals_by_order[item["order_id"]] += item["line_total"]

    order_headers = [
        (1001, 1, date(2026, 6, 1), "COMPLETED", "APPROVED"),
        (1002, 2, date(2026, 6, 1), "COMPLETED", "APPROVED"),
        (1003, 3, date(2026, 6, 2), "PENDING", "PENDING"),
        (1004, 1, date(2026, 6, 3), "REFUNDED", "REFUNDED"),
        (1005, 4, date(2026, 6, 3), "COMPLETED", "APPROVED"),
        (1006, 5, date(2026, 6, 4), "PAID", "APPROVED"),
        (1007, 6, date(2026, 6, 4), "CANCELLED", "DECLINED"),
        (1008, 7, date(2026, 6, 5), "COMPLETED", "APPROVED"),
        (1009, 8, date(2026, 6, 5), "COMPLETED", "APPROVED"),
        (1010, 9, date(2026, 6, 6), "PAID", "APPROVED"),
        (1011, 10, date(2026, 6, 6), "COMPLETED", "APPROVED"),
        (1012, 2, date(2026, 6, 7), "COMPLETED", "APPROVED"),
        (1013, 3, date(2026, 6, 7), "PENDING", "PENDING"),
        (1014, 4, date(2026, 6, 8), "COMPLETED", "APPROVED"),
        (1015, 5, date(2026, 6, 8), "COMPLETED", "APPROVED"),
        (1016, 6, date(2026, 6, 9), "COMPLETED", "APPROVED"),
        (1017, 7, date(2026, 6, 9), "PAID", "APPROVED"),
        (1018, 8, date(2026, 6, 10), "CANCELLED", "DECLINED"),
        (1019, 9, date(2026, 6, 10), "COMPLETED", "APPROVED"),
        (1020, 10, date(2026, 6, 11), "COMPLETED", "APPROVED"),
        (1021, 1, date(2026, 6, 11), "COMPLETED", "APPROVED"),
        (1022, 4, date(2026, 6, 12), "COMPLETED", "APPROVED"),
        (1023, 5, date(2026, 6, 12), "REFUNDED", "REFUNDED"),
        (1024, 6, date(2026, 6, 13), "PENDING", "PENDING"),
    ]

    records: list[dict[str, Any]] = []
    for order_id, customer_id, order_date, order_status, payment_status in order_headers:
        records.append(
            {
                "order_id": order_id,
                "customer_id": customer_id,
                "order_date": order_date,
                "order_status": order_status,
                "payment_status": payment_status,
                "order_total": money(totals_by_order[order_id]),
                "created_at": BASE_TS,
                "updated_at": BASE_TS,
            }
        )
    return records


def validate_data(
    *,
    customers: list[dict[str, Any]],
    products: list[dict[str, Any]],
    orders: list[dict[str, Any]],
    order_items: list[dict[str, Any]],
) -> dict[str, int]:
    """Validate key integrity and monetary consistency before writing files."""
    allowed_order_statuses = {"COMPLETED", "PAID", "PENDING", "CANCELLED", "REFUNDED"}
    allowed_payment_statuses = {"APPROVED", "PENDING", "DECLINED", "REFUNDED"}

    customer_ids = [row["customer_id"] for row in customers]
    product_ids = [row["product_id"] for row in products]
    order_ids = [row["order_id"] for row in orders]
    order_item_ids = [row["order_item_id"] for row in order_items]

    customer_id_set = set(customer_ids)
    product_id_set = set(product_ids)
    order_id_set = set(order_ids)

    totals_by_order: defaultdict[int, Decimal] = defaultdict(lambda: money("0.00"))
    line_total_mismatches = 0

    for item in order_items:
        expected_line_total = money(item["unit_price"] * Decimal(item["quantity"]))
        if money(item["line_total"]) != expected_line_total:
            line_total_mismatches += 1
        totals_by_order[item["order_id"]] += item["line_total"]

    order_total_mismatches = 0
    for order in orders:
        if money(order["order_total"]) != money(totals_by_order[order["order_id"]]):
            order_total_mismatches += 1

    results = {
        "duplicate_customer_ids": duplicate_count(customer_ids),
        "duplicate_product_ids": duplicate_count(product_ids),
        "duplicate_order_ids": duplicate_count(order_ids),
        "duplicate_order_item_ids": duplicate_count(order_item_ids),
        "orders_without_matching_customer": sum(
            1 for order in orders if order["customer_id"] not in customer_id_set
        ),
        "order_items_without_matching_order": sum(
            1 for item in order_items if item["order_id"] not in order_id_set
        ),
        "order_items_without_matching_product": sum(
            1 for item in order_items if item["product_id"] not in product_id_set
        ),
        "negative_order_totals": sum(1 for order in orders if order["order_total"] < 0),
        "negative_line_totals": sum(1 for item in order_items if item["line_total"] < 0),
        "invalid_order_statuses": sum(
            1 for order in orders if order["order_status"] not in allowed_order_statuses
        ),
        "invalid_payment_statuses": sum(
            1 for order in orders if order["payment_status"] not in allowed_payment_statuses
        ),
        "line_total_mismatches": line_total_mismatches,
        "order_total_mismatches": order_total_mismatches,
    }

    failing_checks = {name: value for name, value in results.items() if value != 0}
    if failing_checks:
        formatted = "\n".join(f"- {name}: {value}" for name, value in failing_checks.items())
        raise ValueError(f"Sample data validation failed:\n{formatted}")

    return results


def build_schemas() -> dict[str, pa.Schema]:
    return {
        "customers": pa.schema(
            [
                ("customer_id", pa.int32()),
                ("customer_name", pa.string()),
                ("email", pa.string()),
                ("city", pa.string()),
                ("state_code", pa.string()),
                ("customer_segment", pa.string()),
                ("created_at", pa.timestamp("ms")),
                ("updated_at", pa.timestamp("ms")),
            ]
        ),
        "products": pa.schema(
            [
                ("product_id", pa.int32()),
                ("product_name", pa.string()),
                ("category", pa.string()),
                ("unit_price", pa.decimal128(12, 2)),
                ("is_active", pa.bool_()),
                ("created_at", pa.timestamp("ms")),
                ("updated_at", pa.timestamp("ms")),
            ]
        ),
        "orders": pa.schema(
            [
                ("order_id", pa.int32()),
                ("customer_id", pa.int32()),
                ("order_date", pa.date32()),
                ("order_status", pa.string()),
                ("payment_status", pa.string()),
                ("order_total", pa.decimal128(12, 2)),
                ("created_at", pa.timestamp("ms")),
                ("updated_at", pa.timestamp("ms")),
            ]
        ),
        "order_items": pa.schema(
            [
                ("order_item_id", pa.int32()),
                ("order_id", pa.int32()),
                ("product_id", pa.int32()),
                ("quantity", pa.int32()),
                ("unit_price", pa.decimal128(12, 2)),
                ("line_total", pa.decimal128(12, 2)),
                ("created_at", pa.timestamp("ms")),
                ("updated_at", pa.timestamp("ms")),
            ]
        ),
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Generate controlled synthetic Parquet datasets for Synapse Serverless SQL."
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=DEFAULT_OUTPUT_DIR,
        help="Output directory for generated files. Default: sample_data/generated",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    output_dir = args.output_dir.resolve()

    customers = build_customers()
    products = build_products()
    order_items = build_order_items()
    orders = build_orders(order_items)

    validation_results = validate_data(
        customers=customers,
        products=products,
        orders=orders,
        order_items=order_items,
    )

    clean_directory(output_dir)
    schemas = build_schemas()

    write_dataset(
        dataset_name="customers",
        records=customers,
        schema=schemas["customers"],
        output_dir=output_dir,
    )
    write_dataset(
        dataset_name="products",
        records=products,
        schema=schemas["products"],
        output_dir=output_dir,
    )
    write_dataset(
        dataset_name="orders",
        records=orders,
        schema=schemas["orders"],
        output_dir=output_dir,
    )
    write_dataset(
        dataset_name="order_items",
        records=order_items,
        schema=schemas["order_items"],
        output_dir=output_dir,
    )

    print("Sample data generation completed successfully.")
    print(f"Output directory: {output_dir}")
    print("")
    print("Generated row counts:")
    print(f"- customers:   {len(customers)}")
    print(f"- products:    {len(products)}")
    print(f"- orders:      {len(orders)}")
    print(f"- order_items: {len(order_items)}")
    print("")
    print("Validation checks:")
    for name, value in validation_results.items():
        print(f"- {name}: {value}")
    print("")
    print("Status: PASS")


if __name__ == "__main__":
    main()
