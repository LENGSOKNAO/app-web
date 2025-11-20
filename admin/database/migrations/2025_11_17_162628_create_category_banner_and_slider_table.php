<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('category_banner_and_slider', function (Blueprint $table) {
            $table->id();
            $table->foreignId('banners_id')->nullable()->constrained('banners')->onDelete('cascade');
            $table->foreignId('sliders_id')->nullable()->constrained('sliders')->onDelete('cascade');
            $table->foreignId('banner_app_id')->nullable()->constrained('banner_app')->onDelete('cascade');
            $table->foreignId('slider_app_id')->nullable()->constrained('slider_app')->onDelete('cascade');
            $table->string('category')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('category_banner_and_slider');
    }
};
