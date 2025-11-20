import { Badge } from '@/components/ui/badge';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { SidebarInset } from '@/components/ui/sidebar';
import AppLayout from '@/layouts/app-layout';
import { dashboard } from '@/routes';
import { type BreadcrumbItem } from '@/types';
import { Head } from '@inertiajs/react';
import {
    AlertCircle,
    CheckCircle2,
    ChevronLeft,
    ChevronRight,
    ImageIcon,
    Package,
    Percent,
    Sparkles,
} from 'lucide-react';
import { useState } from 'react';

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: dashboard().url },
    { title: 'Products', href: '/product' },
    { title: 'Product Details', href: '#' },
];

interface Product {
    id: number;
    name: string | null;
    description: string;
    is_active: boolean;
    new_arrival: boolean;
    brand_name: string[];
    category_name: string[];
    tax: number | string;
    sizes: string[];
    colors: string[];
    price: number[];
    stock: number[];
    image: string | string[];
    sub_image: string | string[] | string[][];
    code: string | number;
    discount_amount: string | number;
    start_date: Date | string;
    end_date: Date | string;
}

interface ProductDetailsProps {
    product: Product;
}

// Helper functions
const normalizeImagePath = (path: string): string => {
    if (!path) return '/placeholder-image.jpg';
    if (
        path.startsWith('http') ||
        path.startsWith('blob:') ||
        path.startsWith('data:')
    )
        return path;
    if (path.startsWith('/')) return path;
    return `/storage/${path}`;
};

const formatDate = (date: Date | string): string => {
    return new Date(date).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
    });
};

const useProductDiscount = (product: Product) => {
    const hasDiscount = (): boolean => {
        if (!product.discount_amount) return false;
        const now = new Date();
        const startDate = new Date(product.start_date);
        const endDate = new Date(product.end_date);
        return now >= startDate && now <= endDate && !!product.discount_amount;
    };

    const calculateDiscountedPrice = (basePrice: number): number => {
        if (!hasDiscount()) return basePrice;
        const discount =
            typeof product.discount_amount === 'string'
                ? parseFloat(product.discount_amount)
                : product.discount_amount;
        return basePrice - basePrice * (Number(discount) / 100);
    };

    return { hasDiscount, calculateDiscountedPrice };
};

const useProductVariants = (product: Product) => {
    const getVariantMainImage = (variantIndex: number): string => {
        if (Array.isArray(product.image)) {
            const image = product.image[variantIndex];
            return image ? normalizeImagePath(image) : '/placeholder-image.jpg';
        }
        return variantIndex === 0 && product.image
            ? normalizeImagePath(product.image as string)
            : '/placeholder-image.jpg';
    };

    const getVariantSubImages = (variantIndex: number): string[] => {
        if (!product.sub_image) return [];
        if (Array.isArray(product.sub_image)) {
            const subImages = product.sub_image[variantIndex];
            if (Array.isArray(subImages)) {
                return subImages
                    .map((img) => normalizeImagePath(img))
                    .filter(Boolean);
            } else if (subImages) {
                return [normalizeImagePath(subImages)];
            }
        } else if (variantIndex === 0) {
            return [normalizeImagePath(product.sub_image as string)].filter(
                Boolean,
            );
        }
        return [];
    };

    const getVariants = () => {
        const variantCount = Math.max(
            product.sizes?.length || 0,
            product.colors?.length || 0,
            product.price?.length || 0,
            product.stock?.length || 0,
            1,
        );

        return Array.from({ length: variantCount }).map((_, index) => ({
            size: product.sizes?.[index] || 'One Size',
            color: product.colors?.[index] || 'Default',
            price: product.price?.[index] || 0,
            stock: product.stock?.[index] || 0,
            mainImage: getVariantMainImage(index),
            subImages: getVariantSubImages(index),
        }));
    };

    return getVariants();
};

// Compact Image Modal
const ImageModal = ({
    images,
    isOpen,
    onClose,
    productName,
}: {
    images: string[];
    isOpen: boolean;
    onClose: () => void;
    productName: string;
}) => {
    const [currentImageIndex, setCurrentImageIndex] = useState(0);

    if (!isOpen) return null;

    const currentImage = images[currentImageIndex];

    const nextImage = () => {
        setCurrentImageIndex((prev) =>
            prev === images.length - 1 ? 0 : prev + 1,
        );
    };

    const prevImage = () => {
        setCurrentImageIndex((prev) =>
            prev === 0 ? images.length - 1 : prev - 1,
        );
    };

    const handleBackdropClick = (e: React.MouseEvent) => {
        if (e.target === e.currentTarget) {
            onClose();
        }
    };

    return (
        <div
            className="fixed inset-0 z-50 flex items-center justify-center p-4"
            onClick={handleBackdropClick}
        >
            <div className="relative max-h-full max-w-2xl">
                {/* Main Image */}
                <div className="relative">
                    <img
                        src={currentImage}
                        alt={`${productName} - Image ${currentImageIndex + 1}`}
                        className="max-h-[60vh] max-w-full rounded-lg object-contain"
                    />

                    {/* Navigation Arrows */}
                    {images.length > 1 && (
                        <>
                            <button
                                onClick={prevImage}
                                className="absolute top-1/2 left-2 -translate-y-1/2 transform rounded-full border p-2 transition-all hover:bg-accent"
                                title="Previous image"
                            >
                                <ChevronLeft className="h-4 w-4" />
                            </button>
                            <button
                                onClick={nextImage}
                                className="absolute top-1/2 right-2 -translate-y-1/2 transform rounded-full border p-2 transition-all hover:bg-accent"
                                title="Next image"
                            >
                                <ChevronRight className="h-4 w-4" />
                            </button>
                        </>
                    )}
                </div>

                {/* Image Counter */}
                {images.length > 1 && (
                    <div className="mt-3 text-center text-sm font-medium">
                        {currentImageIndex + 1} / {images.length}
                    </div>
                )}

                {/* Thumbnails */}
                {images.length > 1 && (
                    <div className="mt-3 flex justify-center gap-1">
                        {images.map((image, index) => (
                            <button
                                key={index}
                                onClick={() => setCurrentImageIndex(index)}
                                className={`h-12 w-12 overflow-hidden rounded border transition-all ${
                                    index === currentImageIndex
                                        ? 'border-primary ring-1 ring-primary/20'
                                        : 'border-border hover:border-muted-foreground/50'
                                }`}
                            >
                                <img
                                    src={image}
                                    alt={`Thumbnail ${index + 1}`}
                                    className="h-full w-full object-cover"
                                />
                            </button>
                        ))}
                    </div>
                )}

                {/* Product Name */}
                <div className="mt-2 text-center text-sm font-semibold">
                    {productName}
                </div>
            </div>
        </div>
    );
};

// Compact Product Header
const ProductHeader = ({ product }: { product: Product }) => {
    const { hasDiscount } = useProductDiscount(product);

    return (
        <div className="space-y-3">
            <div className="flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between">
                <div className="space-y-1">
                    <h1 className="text-2xl font-bold tracking-tight">
                        {product.name || 'Unnamed Product'}
                    </h1>
                    <div className="flex flex-wrap items-center gap-1">
                        <Badge
                            variant={
                                product.is_active ? 'default' : 'secondary'
                            }
                            className="text-xs"
                        >
                            {product.is_active ? (
                                <>
                                    <CheckCircle2 className="mr-1 h-3 w-3" />
                                    Active
                                </>
                            ) : (
                                <>
                                    <AlertCircle className="mr-1 h-3 w-3" />
                                    Inactive
                                </>
                            )}
                        </Badge>

                        {product.new_arrival && (
                            <Badge variant="secondary" className="text-xs">
                                <Sparkles className="mr-1 h-3 w-3" />
                                New
                            </Badge>
                        )}

                        {hasDiscount() && (
                            <Badge variant="secondary" className="text-xs">
                                <Percent className="mr-1 h-3 w-3" />
                                Sale
                            </Badge>
                        )}
                    </div>
                </div>

                <div className="rounded border px-2 py-1 text-xs text-muted-foreground">
                    ID: {product.id}
                </div>
            </div>
        </div>
    );
};

// Compact Variant Data Box
const VariantDataBox = ({
    variant,
    product,
}: {
    variant: any;
    product: Product;
}) => {
    const [isModalOpen, setIsModalOpen] = useState(false);
    const { hasDiscount, calculateDiscountedPrice } =
        useProductDiscount(product);

    const allImages = [variant.mainImage, ...variant.subImages].filter(Boolean);
    const hasImages = allImages.length > 0;

    const handleImageClick = (e: React.MouseEvent) => {
        e.stopPropagation();
        if (hasImages) {
            setIsModalOpen(true);
        }
    };

    return (
        <>
            <Card className="overflow-hidden">
                <CardContent className="p-3">
                    <div className="flex items-start justify-between gap-3">
                        {/* Image Thumbnail */}
                        <div className="flex-shrink-0">
                            {hasImages ? (
                                <button
                                    onClick={handleImageClick}
                                    className="group relative flex items-center justify-center overflow-hidden rounded-[1px] border transition-colors hover:border-primary"
                                >
                                    <div className="flex h-20 w-20 items-center justify-center">
                                        <img
                                            src={variant.mainImage}
                                            alt={`${variant.color} ${variant.size}`}
                                            className="h-full w-full object-cover"
                                        />
                                    </div>
                                    {allImages.length > 1 && (
                                        <div className="absolute -top-1 -right-1 flex h-4 w-4 items-center justify-center rounded-full bg-primary text-xs text-primary-foreground">
                                            +{allImages.length - 1}
                                        </div>
                                    )}
                                </button>
                            ) : (
                                <div className="flex h-12 w-12 items-center justify-center rounded border text-muted-foreground">
                                    <ImageIcon className="h-4 w-4" />
                                </div>
                            )}
                        </div>

                        {/* Variant Details */}
                        <div className="min-w-0 flex-1">
                            <div className="mb-1 flex items-start justify-between gap-2">
                                <div>
                                    <h3 className="truncate text-sm font-semibold">
                                        {variant.color} • {variant.size}
                                    </h3>
                                    <p className="text-xs text-muted-foreground">
                                        SKU: {product.code}-{variant.size}-
                                        {variant.color}
                                    </p>
                                </div>
                                <Badge
                                    variant={
                                        variant.stock > 0
                                            ? 'default'
                                            : 'destructive'
                                    }
                                    className="text-xs whitespace-nowrap"
                                >
                                    {variant.stock > 0
                                        ? `${variant.stock} stock`
                                        : 'Out of stock'}
                                </Badge>
                            </div>

                            <div className="flex items-center justify-between">
                                <div className="flex items-center gap-2">
                                    {hasDiscount() && (
                                        <span className="text-xs text-muted-foreground line-through">
                                            ${variant.price}
                                        </span>
                                    )}
                                    <span
                                        className={`text-sm font-bold ${
                                            hasDiscount()
                                                ? 'text-green-600'
                                                : ''
                                        }`}
                                    >
                                        $
                                        {hasDiscount()
                                            ? calculateDiscountedPrice(
                                                  variant.price,
                                              )
                                            : variant.price}
                                    </span>
                                    {hasDiscount() && (
                                        <Badge
                                            variant="secondary"
                                            className="text-xs text-green-700"
                                        >
                                            -{product.discount_amount}%
                                        </Badge>
                                    )}
                                </div>

                                <div className="flex items-center gap-3 text-xs text-muted-foreground">
                                    <div className="flex items-center gap-1">
                                        <div
                                            className="h-3 w-3 rounded-full border"
                                            style={{
                                                backgroundColor:
                                                    variant.color.toLowerCase() ===
                                                    'red'
                                                        ? '#ef4444'
                                                        : variant.color.toLowerCase() ===
                                                            'blue'
                                                          ? '#3b82f6'
                                                          : variant.color.toLowerCase() ===
                                                              'green'
                                                            ? '#10b981'
                                                            : variant.color.toLowerCase() ===
                                                                'black'
                                                              ? '#000000'
                                                              : variant.color.toLowerCase() ===
                                                                  'white'
                                                                ? '#ffffff'
                                                                : '#6b7280',
                                            }}
                                        />
                                        <span className="capitalize">
                                            {variant.color}
                                        </span>
                                    </div>
                                    <span>•</span>
                                    <span>{variant.size}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </CardContent>
            </Card>

            <ImageModal
                images={allImages}
                isOpen={isModalOpen}
                onClose={() => setIsModalOpen(false)}
                productName={`${product.name} - ${variant.color} ${variant.size}`}
            />
        </>
    );
};

// Compact Product Info Sidebar
const ProductInfoSidebar = ({ product }: { product: Product }) => {
    const { hasDiscount } = useProductDiscount(product);

    return (
        <div className="space-y-4">
            <Card>
                <CardHeader className="pb-3">
                    <CardTitle className="flex items-center gap-2 text-base">
                        <Package className="h-4 w-4" />
                        Product Information
                    </CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                    {/* Description */}
                    <div>
                        <p className="mb-1 text-sm font-medium">Description</p>
                        <p className="text-sm leading-relaxed text-muted-foreground">
                            {product.description || 'No description provided.'}
                        </p>
                    </div>

                    {/* Brands */}
                    {product.brand_name?.length > 0 && (
                        <div>
                            <p className="mb-1 text-sm font-medium">Brands</p>
                            <div className="flex flex-wrap gap-1">
                                {product.brand_name.map((brand, index) => (
                                    <Badge
                                        key={index}
                                        variant="secondary"
                                        className="text-xs"
                                    >
                                        {brand}
                                    </Badge>
                                ))}
                            </div>
                        </div>
                    )}

                    {/* Categories */}
                    {product.category_name?.length > 0 && (
                        <div>
                            <p className="mb-1 text-sm font-medium">
                                Categories
                            </p>
                            <div className="flex flex-wrap gap-1">
                                {product.category_name.map(
                                    (category, index) => (
                                        <Badge
                                            key={index}
                                            variant="outline"
                                            className="text-xs"
                                        >
                                            {category}
                                        </Badge>
                                    ),
                                )}
                            </div>
                        </div>
                    )}

                    {/* Tax */}
                    <div className="border-t pt-3">
                        <div className="flex items-center justify-between">
                            <span className="text-sm font-medium">
                                Tax Rate
                            </span>
                            <span className="text-sm font-semibold">
                                {typeof product.tax === 'number'
                                    ? `${product.tax}%`
                                    : product.tax || '0%'}
                            </span>
                        </div>
                    </div>

                    {/* Discount Banner */}
                    {hasDiscount() && (
                        <div className="rounded border p-3">
                            <div className="mb-2 flex items-center gap-1">
                                <Percent className="h-3 w-3" />
                                <p className="text-sm font-semibold">
                                    Special Offer
                                </p>
                            </div>
                            <div className="space-y-2">
                                <div className="flex items-center justify-between">
                                    <span className="text-lg font-bold text-green-600">
                                        {product.discount_amount}% OFF
                                    </span>
                                    <Badge
                                        variant="outline"
                                        className="text-xs"
                                    >
                                        Code: {product.code}
                                    </Badge>
                                </div>
                                <div className="flex justify-between text-xs text-muted-foreground">
                                    <span>
                                        Starts: {formatDate(product.start_date)}
                                    </span>
                                    <span>
                                        Ends: {formatDate(product.end_date)}
                                    </span>
                                </div>
                            </div>
                        </div>
                    )}
                </CardContent>
            </Card>
        </div>
    );
};

// Main Component
export default function ProductDetails({ product }: ProductDetailsProps) {
    const variants = useProductVariants(product);

    return (
        <AppLayout breadcrumbs={breadcrumbs}>
            <Head title={`${product.name || 'Product'} - Details`} />

            <SidebarInset>
                <div className="flex flex-1 flex-col gap-4 p-4">
                    <ProductHeader product={product} />

                    <div className="grid gap-4 lg:grid-cols-3">
                        {/* Variants List */}
                        <div className="space-y-3 lg:col-span-2">
                            <div className="flex items-center justify-between"></div>
                            {variants.map((variant, index) => (
                                <VariantDataBox
                                    key={index}
                                    variant={variant}
                                    product={product}
                                />
                            ))}
                        </div>

                        {/* Sidebar */}
                        <div className="space-y-4">
                            <ProductInfoSidebar product={product} />
                        </div>
                    </div>
                </div>
            </SidebarInset>
        </AppLayout>
    );
}
