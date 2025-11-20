<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SubImage extends Model
{
    protected $table = 'sub_image';

    protected $fillable = [
        'product_image_id',
        'sub_image',
    ];

    public function subImage(): BelongsTo
    {
        return $this->belongsTo(ProductImage::class, 'product_image_id');
    }
}
