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

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.android.nasaapod.network.NasaApi
import com.example.android.nasaapod.network.NasaApiFilter
import com.example.android.nasaapod.network.NasaProperty
import com.squareup.moshi.JsonAdapter
import com.squareup.moshi.Moshi
import com.squareup.moshi.Types
import kotlinx.coroutines.launch
import java.lang.Exception

enum class NasaApiStatus { LOADING, ERROR, DONE }

/**
 * The [ViewModel] that is attached to the [OverviewFragment].
 */
class OverviewViewModel : ViewModel() {

    // The internal MutableLiveData String that stores the most recent response
    private val _status = MutableLiveData<NasaApiStatus>()

    // The external immutable LiveData for the response String
    val status: LiveData<NasaApiStatus>
        get() = _status

    private val _properties = MutableLiveData<List<NasaProperty>>()

    val properties: LiveData<List<NasaProperty>>
        get() = _properties

    private val _navigateToSelectProperty = MutableLiveData<NasaProperty>()
    val navigateToSelectProperty: LiveData<NasaProperty>
        get() = _navigateToSelectProperty

    /**
     * Call getMarsRealEstateProperties() on init so we can display status immediately.
     */
    init {
        //getNasaApodProperty()
        getNasaApodProperties(NasaApiFilter.SHOW_ALL)
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
                        _response.value = "Failure: " + t.message
                        Log.println(3, "err", "message")
                    }
                })
    }
     */

    /**
     * Sets the value of the status LiveData to the Mars API status.
     */
    private fun getNasaApodProperties(filter: NasaApiFilter) {
        viewModelScope.launch {
            _status.value = NasaApiStatus.LOADING
            try {
                _properties.value = NasaApi.retrofitService.getProperties()
                _status.value = NasaApiStatus.DONE

                //Log.d("JSON","JSON->リストに格納されたクラス ${_properties.value} ")
            } catch (e: Exception) {
                _status.value = NasaApiStatus.ERROR

            }
        }

    }

    fun updateFilter(filter: NasaApiFilter) {
        getNasaApodProperties(NasaApiFilter.SHOW_ALL)
    }

    fun displayPropertyDetails(nasaProperty: NasaProperty) {
        _navigateToSelectProperty.value = nasaProperty
    }

    fun displayPropertyDetailsComplete() {
        _navigateToSelectProperty.value = null
    }
}

