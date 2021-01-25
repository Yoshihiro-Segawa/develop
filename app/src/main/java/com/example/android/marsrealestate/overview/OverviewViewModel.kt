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

package com.example.android.marsrealestate.overview

import android.nfc.Tag
import android.util.Log
import androidx.constraintlayout.widget.Constraints.TAG
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.example.android.marsrealestate.network.MarsApi
import com.example.android.marsrealestate.network.MarsProperty
import com.google.android.material.tabs.TabLayout
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.http.*
import retrofit2.converter.gson.GsonConverterFactory

/**
 * The [ViewModel] that is attached to the [OverviewFragment].
 */
class OverviewViewModel : ViewModel() {

    // The internal MutableLiveData String that stores the most recent response
    private val _response = MutableLiveData<MarsProperty>()

    // The external immutable LiveData for the response String
    val response: LiveData<MarsProperty>
        get() = _response

    /**
     * Call getMarsRealEstateProperties() on init so we can display status immediately.
     */
    init {
        getMarsRealEstateProperty()
        //getMarsRealEstateProperties()
    }

    /**
     * Sets the value of the status LiveData to the Mars API status.
     */
    private fun getMarsRealEstateProperty() {
        MarsApi.retrofitService.getProperty()?.enqueue(
                object: Callback<MarsProperty> {
                    override fun onResponse(call: Call<MarsProperty>?, response: Response<MarsProperty>) {
                        _response.value = response.body()
                    }

                    override fun onFailure(call: Call<MarsProperty>, t: Throwable) {
                        //_response.value = "Failure: " + t.message
                    }
                })
    }

    /**
     * Sets the value of the status LiveData to the Mars API status.
     */
    /*
    private fun getMarsRealEstateProperties() {
        MarsApi.retrofitService.getProperties()?.enqueue(
                object: Callback<MarsProperty> {
                    override fun onResponse(call: Call<MutableList<MarsProperty>>?, response: Response<String>) {
                        _response.value = response.body()
                    }

                    override fun onFailure(call: Call<MutableList<MarsProperty>>?, t: Throwable) {
                        _response.value = "Failure: " + t.message
                    }
                })
    }

     */
}
