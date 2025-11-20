<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class ProductImage extends Model
{
    protected $table = 'product_image';

    protected $fillable = [
        'product_variants_id',
        'image'
    ];

    public function product(): BelongsTo
    {
        return $this->belongsTo(ProductVarants::class, 'product_variants_id');
    }
    public function subImage(): HasMany
    {
        return $this->hasMany(SubImage::class, 'product_image_id');
    }
}
