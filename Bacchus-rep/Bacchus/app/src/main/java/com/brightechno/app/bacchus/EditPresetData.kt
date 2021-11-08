package com.brightechno.app.bacchus

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.TextView
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.preference.PreferenceManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.brightechno.app.bacchus.databinding.ActivityEditpresetdataBinding
import com.firebase.ui.firestore.FirestoreRecyclerAdapter
import com.firebase.ui.firestore.FirestoreRecyclerOptions
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.Query
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase

class EditPresetData:AppCompatActivity() {
    private lateinit var binding: ActivityEditpresetdataBinding
    val db: FirebaseFirestore = Firebase.firestore
    var isSetData = false

    private val presetDialogViewModel: PresetDialogViewModel by viewModels()

    companion object {
        const val EXTRA_NAME = "com.brightechno.app.bacchus.transit.NAME"
        const val EXTRA_AMOUNT = "com.brightechno.app.bacchus.transit.AMOUNT"
        const val EXTRA_PERCENT = "com.brightechno.app.bacchus.transit.PERCENT"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val pref = PreferenceManager.getDefaultSharedPreferences(this)
        // 本番環境は直下の行
        val isInit = pref.getBoolean("ISPRESETINIT", false)
        if (isInit == false) {
            // プリセットデータ入力
            return
        }
        binding = ActivityEditpresetdataBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val rv = findViewById<RecyclerView>(R.id.edit_preset)

        val query = db.collection("PresetData").orderBy("name", Query.Direction.DESCENDING)
        val options = FirestoreRecyclerOptions.Builder<preset_data>().setQuery(query, preset_data::class.java)
            .setLifecycleOwner(this).build()
        val adapter = object : FirestoreRecyclerAdapter<preset_data, PresetDataViewHolder>(options) {


            override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): PresetDataViewHolder {
                val view = LayoutInflater.from(this@EditPresetData).inflate(R.layout.list_item2, parent, false)
                return PresetDataViewHolder(view)
            }

            override fun onBindViewHolder(
                holder: PresetDataViewHolder,
                position: Int,
                model: preset_data
            ) {
                val drinkName = holder.itemView.findViewById<TextView>(R.id.drinkName2)
                drinkName.text = model.name.toString()
                val drinkAmount = holder.itemView.findViewById<TextView>(R.id.drinkAmount2)
                drinkAmount.text = "酒量"+model.amount.toString()+"ml"
                //drinkAmount.text = model.amount.toString()
                val drinkPercent = holder.itemView.findViewById<TextView>(R.id.drinkPercent2)
                drinkPercent.text = "度数"+model.percent.toString()+"%"
                //drinkPercent.text = model.percent.toString()

                val drinkData = getItem(position)
                holder.itemView.setOnClickListener {
                    Log.d("MyApp3",model.name+"編集用選択されました")
                    editPresetDialog(model.name.toString(), model.amount, model.percent)
                }
            }
        }

        rv.setHasFixedSize(true)
        rv.adapter = adapter
        rv.layoutManager = LinearLayoutManager(this)
        adapter.startListening()

        binding.closeEditPreset.setOnClickListener {
            finish()
        }
    }

    fun editPresetDialog(name: String, amount: Int, percent: Double) {
        Log.d("MyApp3", "Data Selected")
        val dialog = EditPresetFragment()
        dialog.show(supportFragmentManager, "long")

        presetDialogViewModel.state.observe(this) {
            when (it) {
                is PresetDialogState.Edit -> {
                    editDeletePresetData(name, amount, percent, true)
                }
                is PresetDialogState.Delete -> {
                    editDeletePresetData(name, amount, percent, false)
                }
            }
        }
    }

    private fun editDeletePresetData(name: String, amount: Int, percent: Double, isEdit: Boolean) {
        val presetData = preset_data(name, amount, percent)
        if(isEdit == true) {
            val intent = Intent(this, EditPreset::class.java)
            setData(name, amount, percent, intent)
            startActivity(intent)
        }
        else {
            db.collection("PresetData")
                .whereEqualTo("name", name)
                .whereEqualTo("amount", amount)
                .whereEqualTo("percent", percent)
                .get()
                .addOnSuccessListener { documents ->
                    for (document in documents) {
                        Log.d("App", "delete cand. ${document.id} => ${document.data}")
                        db.collection("PresetData").document(document.id)
                            .delete()
                    }
                }
                .addOnFailureListener { exception ->
                    Log.w("App", "Error getting documents: ", exception)
                }
        }
    }

    private fun setData(name: String, amount: Int, percent: Double, intent: Intent) {
        intent.putExtra(EXTRA_NAME, name)
        intent.putExtra(EXTRA_AMOUNT, amount)
        intent.putExtra(EXTRA_PERCENT, percent)
        setResult(Activity.RESULT_OK, intent)
    }
}

