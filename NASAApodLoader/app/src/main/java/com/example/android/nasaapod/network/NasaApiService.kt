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

import com.squareup.moshi.JsonAdapter
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.http.*
import com.squareup.moshi.Moshi
import com.squareup.moshi.Types
import com.squareup.moshi.kotlin.reflect.KotlinJsonAdapterFactory
import retrofit2.converter.moshi.MoshiConverterFactory

enum class NasaApiFilter(val value: String) {
    SHOW_IMAGE("&media_type=image"),
    SHOW_VIDEO("&media_type=video"),
    SHOW_ALL(""),
    SHOW_DATE("StartDate"),
    SHOW_COUNT("count")
}

private const val BASE_URL = "https://api.nasa.gov/planetary/apod/"
//private const val BASE_URL = "https://api.nasa.gov/techport/api/specification/"
//private const val BASE_URL = "https://android-kotlin-fun-mars-server.appspot.com"
//private const val BASE_URL = "https://api.nasa.gov/insight_weather/"
//private const val BASE_URL = "http://api.openweathermap.org/data/2.5/weather/"

/**
 * Build the Moshi object that Retrofit will be using, making sure to add the Kotlin adapter for
 * full Kotlin compatibility.
 */
/* moshiでも動くね */

private val moshi = Moshi.Builder()
        .add(KotlinJsonAdapterFactory())
        .build()

/**
 * Use the Retrofit builder to build a retrofit object using a Moshi converter with our Moshi
 * object.
 */

private val retrofit = Retrofit.Builder()
        .addConverterFactory(MoshiConverterFactory.create(moshi))
        .baseUrl(BASE_URL)
        .build()

/*
private val retrofit = Retrofit.Builder()
        .addConverterFactory(ScalarsConverterFactory.create())
        .baseUrl(BASE_URL)
        .build()

 */

/* 当面 GSON でパースする */
/*
private val retrofit = Retrofit.Builder()
        .addConverterFactory(GsonConverterFactory.create())
        .baseUrl(BASE_URL)
        .build()

 */

interface NasaApiService {
    /*  BASE_URLに対してのリクエストを＠GETで送信 */

    @GET ("?api_key=NWeQMmUrdSDuOBbLewFpkOz0JvZgFzWgZvmsnaa2&date=2021-01-19")
    //@GET ("?api_key=NWeQMmUrdSDuOBbLewFpkOz0JvZgFzWgZvmsnaa2&count=1")
    fun getProperty(): Call<NasaProperty>

    @GET ("?api_key=NWeQMmUrdSDuOBbLewFpkOz0JvZgFzWgZvmsnaa2&count=10")
    suspend fun getProperties(): List<NasaProperty>

    @GET ("?api_key=NWeQMmUrdSDuOBbLewFpkOz0JvZgFzWgZvmsnaa2")
    suspend fun getDatabyStartDate(@Query("start_date") startDate: String): List<NasaProperty>

    @GET ("?api_key=NWeQMmUrdSDuOBbLewFpkOz0JvZgFzWgZvmsnaa2")
    suspend fun getDatabyCount(@Query("count") counts: Int): List<NasaProperty>

    @GET ("?api_key=NWeQMmUrdSDuOBbLewFpkOz0JvZgFzWgZvmsnaa2")
    suspend fun getDatabyStartDateAndCount(@Query("start_date") startDate: String,
                                           @Query("count") counts: Int): List<NasaProperty>

}

object NasaApi {
    val retrofitService : NasaApiService by lazy { retrofit.create(NasaApiService::class.java) }
}