package com.example.android.nasaapod.database

//import androidx.lifecycle.LiveData
//import androidx.room.Dao
//import androidx.room.Insert
//import androidx.room.Query
//import androidx.room.Update
//import com.example.android.nasaapod.network.NasaProperty
//
//@Dao
//interface ApodDatabaseDao {
//
//    @Insert
//    suspend fun insert(data: Apoddata)
//
//    @Update
//    suspend fun update(data: Apoddata)
//
//    @Query("SELECT * from nasa_apod_content_table where date = :key")
//    suspend fun get(key: String): Apoddata
//
//    @Query("DELETE FROM nasa_apod_content_table")
//    suspend fun clear()
//
//    @Query("SELECT * FROM nasa_apod_content_table ORDER BY date DESC")
//    fun getAllApodData(): LiveData<List<Apoddata>>
//
//    @Query("SELECT * FROM nasa_apod_content_table ORDER BY date DESC LIMIT 1")
//    suspend fun getApodData(): Apoddata?
//}
//
