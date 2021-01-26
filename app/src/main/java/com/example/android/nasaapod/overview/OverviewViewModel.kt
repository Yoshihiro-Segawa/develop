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

package com.example.android.nasaapod.overview

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.android.nasaapod.network.NasaApi
import com.example.android.nasaapod.network.NasaProperty
import kotlinx.coroutines.launch
import java.lang.Exception

/**
 * The [ViewModel] that is attached to the [OverviewFragment].
 */
class OverviewViewModel : ViewModel() {

    // The internal MutableLiveData String that stores the most recent response
    private val _response = MutableLiveData<NasaProperty>()

    // The external immutable LiveData for the response String
    val response: LiveData<NasaProperty>
        get() = _response

    private val _properties = MutableLiveData<List<NasaProperty>>()

    val properties: LiveData<List<NasaProperty>>
        get() = _properties

    /**
     * Call getMarsRealEstateProperties() on init so we can display status immediately.
     */
    init {
        //getNasaApodProperty()
        getNasaApodProperties()
    }

    /**
     * Sets the value of the status LiveData to the Mars API status.
     */
    /*
    private fun getNasaApodProperty() {
        NasaApi.retrofitService.getProperty()?.enqueue(
                object: Callback<NasaProperty> {
                    override fun onResponse(call: Call<Array<NasaProperty>>?, response: Response<Array<NasaProperty>>) {
                        _response.value = response.body()
                    }

                    override fun onFailure(call: Call<NasaProperty>, t: Throwable) {
                        //_response.value = "Failure: " + t.message
                        Log.println(3, "err", "message")
                    }
                })
    }

     */





    /**
     * Sets the value of the status LiveData to the Mars API status.
     */

    private fun getNasaApodProperties() {
        viewModelScope.launch {
            try {
                _properties.value = NasaApi.RETROFIT_SERVICE.getProperties()
            } catch (e: Exception) {

            }
        }
    }


}
