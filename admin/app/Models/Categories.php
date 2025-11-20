<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;


class Categories extends Model
{
    protected $table = 'categories';

    protected $fillable = [
        'products_id',
        'category_name',
        'description',
    ];

    public function product(): BelongsTo
    {
        return $this->belongsTo(Products::class, 'products_id');
    }
}
