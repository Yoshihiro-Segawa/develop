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

import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.scalars.ScalarsConverterFactory
import retrofit2.http.GET

private const val BASE_URL = "https://api.nasa.gov/planetary/apod/"
//private const val BASE_URL = "https://api.nasa.gov/techport/api/specification/"
//private const val BASE_URL = "https://android-kotlin-fun-mars-server.appspot.com"
//private const val BASE_URL = "https://api.nasa.gov/insight_weather/"
//private const val BASE_URL = "http://api.openweathermap.org/data/2.5/weather/"


private val retrofit = Retrofit.Builder()
        .addConverterFactory(ScalarsConverterFactory.create())
        .baseUrl(BASE_URL)
        .build()

interface MarsApiService {
    @GET ("?api_key=NWeQMmUrdSDuOBbLewFpkOz0JvZgFzWgZvmsnaa2")
    //@GET("?api_key=DEMO_KEY")
    //@GET("realestate")
    //@GET("?api_key=DEMO_KEY&feedtype=json&ver=1.0")
    //@GET("?q=London,uk&APPID=bd2cc82bac421b5e74979f0bc521d9e2")
    fun getProperties():
            Call<String>
}

object MarsApi {
    val retrofitService : MarsApiService by lazy {
        retrofit.create(MarsApiService::class.java) }
}