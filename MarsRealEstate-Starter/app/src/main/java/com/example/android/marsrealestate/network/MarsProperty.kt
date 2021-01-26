/*
 * Copyright 2019, The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

package com.example.android.marsrealestate.network

import android.os.Parcelable
import com.example.android.marsrealestate.R
import com.squareup.moshi.Json
import kotlinx.android.parcel.Parcelize

enum class MarsApiFilter(val value: String) {
    SHOW_RENT("rent"),
    SHOW_BUY("buy"),
    SHOW_ALL("all")
}

/**
 * This data class defines a Mars property which includes an ID, the image URL, the type (sale
 * or rental) and the price (monthly if it's a rental).
 * The property names of this data class are used by Moshi to match the names of values in JSON.
 */
@Parcelize
data class MarsProperty(
        val id: String,
        // used to map img_src from the JSON to imgSrcUrl in our class
        @Json(name = "img_src") val imgSrcUrl: String,
        val type: String,
        val price: Double) : Parcelable {
    val isRental
        get() = type == "rent"

    fun displayPropertyType(): String {
        val s : String = "R.string.display_type"

        return when(isRental) {
            true -> s.format(R.string.type_rent)
            false -> s.format(R.string.type_sale)
        }
    }

    fun displayPropertyPrice() : String {
        val s1 : String = "R.string.display_price"
        val s2 : String = "R.string.display_price_monthly_rental"

        return when (isRental) {
            true -> s2.format(price)
            false -> s1.format(price)
        }
    }
}