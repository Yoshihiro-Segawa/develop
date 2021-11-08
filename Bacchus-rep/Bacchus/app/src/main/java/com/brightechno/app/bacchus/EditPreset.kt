package com.brightechno.app.bacchus

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.brightechno.app.bacchus.databinding.ActivityAddnewpresetdataBinding
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase

class EditPreset: AppCompatActivity() {
    private lateinit var binding: ActivityAddnewpresetdataBinding
    val db: FirebaseFirestore = Firebase.firestore
    private lateinit var presetName: String
    private var presetAmount: Int = 0
    private var presetPercent: Double = 0.0


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityAddnewpresetdataBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val name = intent.getStringExtra(EditPresetData.EXTRA_NAME)
        val name_text = name
        binding.editPresetName.setText(name_text)
        val amount = intent.getIntExtra(EditPresetData.EXTRA_AMOUNT, 0)
        val amount_text = amount.toString()
        binding.editPresetAmount.setText(amount_text)
        val percent = intent.getDoubleExtra(EditPresetData.EXTRA_PERCENT, 0.0)
        val percent_text = percent.toString()
        binding.editPresetPercent.setText(percent_text)

        binding.presetConfFixButton.setOnClickListener {
            val check = validationCheck()

            if (check) {
                setPresetNameText()
                setPresetAmount()
                setPresetPercent()

                db.collection("PresetData")
                    .whereEqualTo("name", name)
                    .whereEqualTo("amount", amount)
                    .whereEqualTo("percent", percent)
                    .get()
                    .addOnSuccessListener { documents ->
                        for (document in documents) {

                            Log.d("App", "edit cand. ${document.id} => ${document.data} to ${presetName} ${presetAmount} ${presetPercent}")
                            val presetData = preset_data(presetName, presetAmount, presetPercent)
                            db.collection("PresetData").document(document.id).set(presetData)
                        }}
                finish()
            }
        }

    }

    private fun validationCheck() : Boolean {
        if(binding.editPresetName.text.length == 0) {
            binding.editPresetName.requestFocus()
            Toast.makeText(applicationContext, getString(R.string.let_input_preset_name), Toast.LENGTH_SHORT)
            return false
        }
        if (binding.editPresetAmount.text.length == 0) {
            binding.editPresetAmount.requestFocus()
            Toast.makeText(applicationContext, getString(R.string.let_input_preset_amount), Toast.LENGTH_SHORT)
            return false
        }
        if (binding.editPresetPercent.text.length == 0) {
            binding.editPresetPercent.requestFocus()
            Toast.makeText(applicationContext, getString(R.string.let_input_preset_percent), Toast.LENGTH_SHORT)
            return false
        }
        return true
    }


    private fun setPresetNameText() {
        presetName = binding.editPresetName.text.toString()
    }

    private fun setPresetAmount() {
        presetAmount = binding.editPresetAmount.text.toString().toInt()
    }

    private fun setPresetPercent() {
        presetPercent = binding.editPresetPercent.text.toString().toDouble()
    }

    private fun setData(name: String, amount: Int, percent: Double) {
        intent = Intent()
        intent.putExtra("DATA_NAME", name)
        intent.putExtra("DATA_AMOUNT", amount)
        intent.putExtra("DATA_PERCENT", percent)
        setResult(Activity.RESULT_OK, intent)
    }

}