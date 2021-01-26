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

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.example.android.nasaapod.databinding.ListViewItemBinding
import com.example.android.nasaapod.network.NasaProperty

/**
 * This class implements a [RecyclerView] [ListAdapter] which uses Data Binding to present [List]
 * data, including computing diffs between lists.
 */
class PhotoGridAdapter( private val onClickListener: OnClickListener) :
        ListAdapter<NasaProperty,
                PhotoGridAdapter.NasaPropertyViewHolder>(DiffCallback) {

    /**
     * The MarsPropertyViewHolder constructor takes the binding variable from the associated
     * GridViewItem, which nicely gives it access to the full [MarsProperty] information.
     */
    class NasaPropertyViewHolder(private var binding: ListViewItemBinding):
            RecyclerView.ViewHolder(binding.root) {
        fun bind(nasaProperty: NasaProperty) {
            binding.property = nasaProperty
            // This is important, because it forces the data binding to execute immediately,
            // which allows the RecyclerView to make the correct view size measurements
            binding.executePendingBindings()
        }
    }

    /**
     * Allows the RecyclerView to determine which items have changed when the [List] of [MarsProperty]
     * has been updated.
     */
    companion object DiffCallback : DiffUtil.ItemCallback<NasaProperty>() {
        override fun areItemsTheSame(oldItem: NasaProperty, newItem: NasaProperty): Boolean {
            return oldItem === newItem
        }

        override fun areContentsTheSame(oldItem: NasaProperty, newItem: NasaProperty): Boolean {
            return oldItem.date == newItem.date
        }
    }

    /**
     * Create new [RecyclerView] item views (invoked by the layout manager)
     */
    override fun onCreateViewHolder(parent: ViewGroup,
                                    viewType: Int): NasaPropertyViewHolder {
        return NasaPropertyViewHolder(ListViewItemBinding.inflate(LayoutInflater.from(parent.context)))
    }

    /**
     * Replaces the contents of a view (invoked by the layout manager)
     */
    override fun onBindViewHolder(holder: NasaPropertyViewHolder, position: Int) {
        val nasaProperty = getItem(position)
        holder.itemView.setOnClickListener{
            onClickListener.onClick(nasaProperty)
        }
        holder.bind(nasaProperty)
    }

    class OnClickListener(val clickListener: (marsProperty:NasaProperty) -> Unit) {
        fun onClick(nasaProperty: NasaProperty) = clickListener(nasaProperty)
    }


}
