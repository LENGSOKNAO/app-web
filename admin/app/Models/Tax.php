<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Tax extends Model
{
    protected $table = 'tax';

    protected $fillable = [
        'products_id',
        'tax',
    ];  

    public function product(): BelongsTo
    {
        return $this->belongsTo(Products::class, 'products_id');
    }
}
