package com.brightechno.app.bacchus

import android.app.AlertDialog
import android.app.Dialog
import android.os.Bundle
import androidx.core.os.bundleOf
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.viewModels
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel

class EditPresetFragment: DialogFragment() {

    companion object {
        private const val BUNDLE_KEY_TITLE = "bundle_key_title"
        private const val BUNDLE_KEY_MESSAGE = "bundle_key_message"

        private fun newInstance() = EditPresetFragment()

        private fun newInstance(title: String, message: String): EditPresetFragment {
            return newInstance().apply {
                arguments = bundleOf(
                    Pair(BUNDLE_KEY_TITLE, title),
                    Pair(BUNDLE_KEY_MESSAGE, message)
                )
            }
        }

        fun show(title: String, message: String, fragmentManager: FragmentManager, tag: String) {
            newInstance(title, message).run {
                show(fragmentManager, tag)
            }
        }
    }

    lateinit var title: String
    lateinit var message: String



    private val viewModel: PresetDialogViewModel by viewModels({ requireActivity() })

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        val builder = AlertDialog.Builder(activity)
        builder.setTitle("選択してください")
            .setCancelable(false)
            .setItems(R.array.preset_edit_array) { dialog, which ->
                when (which) {
                    0 -> {
                        viewModel.state.value = PresetDialogState.Edit(this@EditPresetFragment)
                    }
                    1 -> {
                        viewModel.state.value = PresetDialogState.Delete(this@EditPresetFragment)
                    }
                }
                val langs = resources.getStringArray(R.array.preset_edit_array)
                println(langs[which])
            }

        return builder.create()
    }

}

sealed class PresetDialogState<T : DialogFragment> {
    data class Edit<T : DialogFragment>(val dialog: T) : PresetDialogState<T>()
    data class Delete<T : DialogFragment>(val dialog: T) : PresetDialogState<T>()
    data class None<T : DialogFragment>(val dialog: T) : PresetDialogState<T>()
}

class PresetDialogViewModel: ViewModel() {
    val state = MutableLiveData<PresetDialogState<EditPresetFragment>>()
}