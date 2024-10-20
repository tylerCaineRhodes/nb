frompyspark.sql.dataframe import DataFrame
import scrapyard.eval.spark.volumes as volumes


def add_gross_volumes(well_slots_with_drilling_schedule):
    blended_type_curves_df = _create_blended_type_curves(
        well_slots_with_drilling_schedule
    )

    df = _add_production_volumes_by_month(well_slots_with_drilling_schedule)
    unblended_volumes_df = _apply_dev_area_well_proportions(df)

    if dataframe_exists(blended_type_curves_df) and dataframe_exists(
        unblended_volumes_df
    ):

        combined_df = unblended_volumes_df.join(
            blended_type_curves_df,
            how="left",
            on=["development_area_name", "reservoir_category", "month"],
        )

        return (
            combined_df.withColumn(
                "coalesced_gas",
                F.when(
                    (
                        (F.col("reservoir_category") == "ltd")
                        & (F.col("ltd_blend") == True)
                    ),
                    F.col("blended_gas"),
                ).otherwise(
                    F.when(
                        (
                            (F.col("reservoir_category") == "ntd")
                            & (F.col("ntd_blend") == True)
                        ),
                        F.col("blended_gas"),
                    ).otherwise(F.col("gas"))
                ),
            )
            .withColumn(
                "coalesced_liquid",
                F.when(
                    (
                        (F.col("reservoir_category") == "ltd")
                        & (F.col("ltd_blend") == True)
                    ),
                    F.col("blended_liquid"),
                ).otherwise(
                    F.when(
                        (
                            (F.col("reservoir_category") == "ntd")
                            & (F.col("ntd_blend") == True)
                        ),
                        F.col("blended_liquid"),
                    ).otherwise(F.col("liquid"))
                ),
            )
            .withColumn(
                "coalesced_water",
                F.when(
                    (
                        (F.col("reservoir_category") == "ltd")
                        & (F.col("ltd_blend") == True)
                    ),
                    F.col("blended_water"),
                ).otherwise(
                    F.when(
                        (
                            (F.col("reservoir_category") == "ntd")
                            & (F.col("ntd_blend") == True)
                        ),
                        F.col("blended_water"),
                    ).otherwise(F.col("water"))
                ),
            )
        )
    # drop gas, liquid, water,"month", "blended_gas", "blended_liquid", "blended_water"
    # rename complete columns,
    #         return (
    #             combined_df.withColumn(
    #                 "gas", F.coalesce(F.col("blended_gas"), F.col("gas"))
    #             )
    #             .withColumn("liquid", F.coalesce(F.col("blended_liquid"), F.col("liquid")))
    #             .withColumn("water", F.coalesce(F.col("blended_water"), F.col("water")))
    #             .drop("month", "blended_gas", "blended_liquid", "blended_water")
    #         )

    elif dataframe_exists(unblended_volumes_df):
        return unblended_volumes_df.drop("month")
    elif dataframe_exists(blended_type_curves_df):
        return blended_type_curves_df.drop("month")
    else:
        return None


def dataframe_exists(df):
    if df is None:
        return False
    if not isinstance(df, DataFrame):
        return False
    return True


def _create_blended_type_curves(well_slots_with_drilling_schedule):
    blended_ltd_df = _add_blended_volumes(well_slots_with_drilling_schedule, "ltd")
    print(blended_ltd_df.count(), "ltd_count")

    blended_ntd_df = _add_blended_volumes(well_slots_with_drilling_schedule, "ntd")
    print(blended_ntd_df.count(), "ntd_count")

    if dataframe_exists(blended_ltd_df) and dataframe_exists(blended_ntd_df):
        return blended_ltd_df.union(blended_ntd_df)
    elif dataframe_exists(blended_ltd_df):
        return blended_ltd_df
    elif dataframe_exists(blended_ntd_df):
        return blended_ntd_df
    else:
        return None


def _add_blended_volumes(well_slots_with_drilling_schedule, rescat):
    slot_count_per_rescat_df = well_slots_with_drilling_schedule.groupBy(
        "development_area_name", "reservoir_category"
    ).agg(F.count("slot_number").alias("slots_per_rescat"))

    dev_area_wells_df = well_slots_with_drilling_schedule.where(
        F.col("reservoir_category") == rescat
    )
    exploded_df = (
        dev_area_wells_df.join(
            slot_count_per_rescat_df,
            on=["development_area_name", "reservoir_category"],
            how="inner",
        )
        .withColumn("forecast_record", F.explode("adjusted_forecast_records"))
        .withColumn("month", F.col("forecast_record.month"))
        .withColumn("liquid", F.col("forecast_record.liquid"))
        .withColumn("gas", F.col("forecast_record.gas"))
        .withColumn("water", F.col("forecast_record.water"))
        .withColumn("slots_per_rescat", F.col("slots_per_rescat"))
    )

    exploded_df = _apply_dev_area_well_proportions_for_blended(exploded_df)

    return (
        exploded_df.groupBy(
            "development_area_name", "reservoir_category", "slots_per_rescat", "month"
        )
        .agg(
            (F.sum("liquid") / F.max("slots_per_rescat")).alias("blended_liquid"),
            (F.sum("gas") / F.max("slots_per_rescat")).alias("blended_gas"),
            (F.sum("water") / F.max("slots_per_rescat")).alias("blended_water"),
        )
        .orderBy(
            "development_area_name", "reservoir_category", "slots_per_rescat", "month"
        )
    )
