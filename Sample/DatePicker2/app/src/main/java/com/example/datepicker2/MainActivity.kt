package com.example.datepicker2

import android.app.DatePickerDialog
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.TextView


class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val button = findViewById<Button>(R.id.button)

        button.setOnClickListener {
            showDatePicker()
        }

    }
    private fun showDatePicker() {
        val textView = findViewById<TextView>(R.id.textView)

        val datePickerDialog = DatePickerDialog(
                this,
                DatePickerDialog.OnDateSetListener() {view, year, month, dayOfMonth->
                    textView.text = "選択した日付は「${year}/${month + 1}/${dayOfMonth}」です"
                },
                2021,
                2,
                1)
        datePickerDialog.show()
    }
}