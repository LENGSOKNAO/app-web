<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Sliders extends Model
{
    protected $table = 'sliders';

    protected $fillable = ['title', 'subtitle', 'is_active'];

    protected $casts = ['is_active' => 'boolean'];

    public function images(): HasMany 
    {
        return $this->hasMany(Images::class, 'sliders_id');
    }

    public function category(): HasMany 
    {
        return $this->hasMany(TypeBannerOrSlider::class, 'sliders_id');
    }
}
