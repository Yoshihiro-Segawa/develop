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

package com.example.android.nasaapod.network

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize

/*　この構造体でパースする */
@Parcelize
data class NasaProperty(
    var copyright: String?,
    var date: String,
    var explanation: String,
    var hdurl: String,
    var media_type: String,
    var service_version: String,
    var title: String,
    var url: String) : Parcelable {
        fun to_s(): String = "${date} ${title} ${url}"
    }

