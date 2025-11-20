import { Badge } from '@/components/ui/badge';
import { Card, CardContent } from '@/components/ui/card';
import { SidebarInset } from '@/components/ui/sidebar';
import AppLayout from '@/layouts/app-layout';
import { dashboard, order } from '@/routes';
import { type BreadcrumbItem } from '@/types';
import { Head } from '@inertiajs/react';
import {
    AlertCircle,
    Calendar,
    CheckCircle2,
    ChevronLeft,
    ChevronRight,
    CreditCard,
    Mail,
    Package,
    Sparkles,
    Truck,
    User,
} from 'lucide-react';
import { useState } from 'react';

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: dashboard().url },
    { title: 'Orders', href: order().url },
    { title: 'Order Details', href: '#' },
];

interface OrderItem {
    id: number;
    orders_id: number;
    products_id: number;
    product_variants_id: number;
    size: string;
    color: string;
    qty: number;
    price: string;
    created_at: string;
    updated_at: string;
    product: {
        id: number;
        name: string;
        description: string;
        is_active: boolean;
        new_arrival: boolean;
        created_at: string;
        updated_at: string;
        brand: any[];
    };
    product_variant: {
        id: number;
        products_id: number;
        price: string;
        sizes: string | null;
        colors: string | null;
        stock: number;
        created_at: string;
        updated_at: string;
        images: Array<{
            id: number;
            image: string;
            is_primary?: boolean;
            created_at?: string;
            updated_at?: string;
        }>;
    };
}

interface Order {
    id: number;
    users_id: number;
    total: string;
    shipping_method: string;
    status: string;
    created_at: string;
    updated_at: string;
    user: {
        id: number;
        first_name: string;
        last_name: string;
        email: string;
        role: string;
        profile: string | null;
    };
    address: {
        id: number;
        address_line1: string;
        address_line2: string | null;
        city: string;
        state: string;
        postal_code: string;
        country: string;
    }[];
    payment: {
        id: number;
        payment_method: string;
        payment_status: string;
        payment_transaction_id: string;
    }[];
    items: OrderItem[];
}

interface OrderDetailsProps {
    order: Order;
}

// Helper functions
const formatCurrency = (amount: number): string => {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD',
    }).format(amount);
};

const formatDate = (date: string): string => {
    return new Date(date).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
    });
};

// Simple Image Modal Component without background
const ImageModal = ({
    isOpen,
    onClose,
    images,
    productName,
}: {
    isOpen: boolean;
    onClose: () => void;
    images: Array<{ id: number; image: string; is_primary?: boolean }>;
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
            className="fixed inset-0 z-50 flex items-center justify-center"
            onClick={handleBackdropClick}
        >
            {/* Main Image Container */}
            <div className="relative max-h-full max-w-4xl">
                {/* Main Image */}
                <div className="relative">
                    <img
                        src={`/storage/${currentImage.image}`}
                        alt={`${productName} - Image ${currentImageIndex + 1}`}
                        className="max-h-[80vh] max-w-full rounded-lg object-contain shadow-2xl"
                    />

                    {/* Navigation Arrows */}
                    {images.length > 1 && (
                        <>
                            <button
                                onClick={prevImage}
                                className="absolute top-1/2 left-4 -translate-y-1/2 transform rounded-full bg-white p-3 text-gray-700 shadow-lg transition-all hover:bg-gray-100"
                                title="Previous image"
                            >
                                <ChevronLeft className="h-6 w-6" />
                            </button>
                            <button
                                onClick={nextImage}
                                className="absolute top-1/2 right-4 -translate-y-1/2 transform rounded-full bg-white p-3 text-gray-700 shadow-lg transition-all hover:bg-gray-100"
                                title="Next image"
                            >
                                <ChevronRight className="h-6 w-6" />
                            </button>
                        </>
                    )}
                </div>

                {/* Image Counter */}
                <div className="mt-4 text-center font-medium text-gray-700">
                    {currentImageIndex + 1} / {images.length}
                </div>

                {/* Thumbnails */}
                {images.length > 1 && (
                    <div className="mt-4 flex justify-center gap-2">
                        {images.map((image, index) => (
                            <button
                                key={image.id}
                                onClick={() => setCurrentImageIndex(index)}
                                className={`h-16 w-16 overflow-hidden rounded-lg border-2 transition-all ${
                                    index === currentImageIndex
                                        ? 'border-blue-500 ring-2 ring-blue-300'
                                        : 'border-gray-300 hover:border-gray-400'
                                }`}
                            >
                                <img
                                    src={`/storage/${image.image}`}
                                    alt={`Thumbnail ${index + 1}`}
                                    className="h-full w-full object-cover"
                                />
                            </button>
                        ))}
                    </div>
                )}

                {/* Product Name */}
                <div className="mt-2 text-center text-lg font-semibold text-gray-900">
                    {productName}
                </div>
            </div>
        </div>
    );
};

// Updated ProductImage component with click functionality
const ProductImage = ({ item }: { item: OrderItem }) => {
    const [imageError, setImageError] = useState(false);
    const [isModalOpen, setIsModalOpen] = useState(false);

    // Get the first image if available
    let imageUrl = null;
    if (item.product_variant?.images?.length > 0) {
        const firstImage = item.product_variant.images[0];
        imageUrl = `/storage/${firstImage.image}`;
    } else {
        console.log('❌ No images found in product_variant.images');
    }

    const handleImageError = (
        e: React.SyntheticEvent<HTMLImageElement, Event>,
    ) => {
        console.log('🚨 Image failed to load:', imageUrl);
        console.log('🖼️ Image element:', e.currentTarget);
        setImageError(true);
    };

    const handleImageLoad = () => {
        console.log('✅ Image loaded successfully:', imageUrl);
    };

    const handleImageClick = (e: React.MouseEvent) => {
        // Stop event propagation to prevent clicks from affecting parent elements
        e.stopPropagation();
        e.preventDefault();

        if (
            imageUrl &&
            !imageError &&
            item.product_variant?.images?.length > 0
        ) {
            setIsModalOpen(true);
        }
    };

    if (imageUrl && !imageError) {
        return (
            <>
                <div
                    className="flex-shrink-0"
                    onClick={(e) => e.stopPropagation()}
                >
                    <img
                        src={imageUrl}
                        alt={item.product.name}
                        className="h-24 w-24 cursor-pointer rounded-lg border object-cover transition-opacity hover:opacity-80"
                        onError={handleImageError}
                        onLoad={handleImageLoad}
                        onClick={handleImageClick}
                    />
                    {item.product_variant?.images?.length > 1 && (
                        <div className="mt-1 text-center text-xs text-blue-600">
                            +{item.product_variant.images.length - 1} more
                        </div>
                    )}
                </div>

                <ImageModal
                    isOpen={isModalOpen}
                    onClose={() => setIsModalOpen(false)}
                    images={item.product_variant.images}
                    productName={item.product.name}
                />
            </>
        );
    }

    return (
        <div className="flex-shrink-0" onClick={(e) => e.stopPropagation()}>
            <div className="flex h-24 w-24 items-center justify-center rounded-lg border bg-gray-100">
                <Package className="h-8 w-8 text-gray-400" />
            </div>
            <div className="mt-1 text-center text-xs text-red-500">
                {imageError ? 'Failed to load' : 'No image'}
            </div>
        </div>
    );
};

// Order Status Badge
const OrderStatusBadge = ({ status }: { status: string }) => {
    const statusConfig = {
        pending: {
            label: 'Pending',
            color: 'bg-yellow-100 text-yellow-800 border-yellow-200',
        },
        processing: {
            label: 'Processing',
            color: 'bg-blue-100 text-blue-800 border-blue-200',
        },
        shipped: {
            label: 'Shipped',
            color: 'bg-purple-100 text-purple-800 border-purple-200',
        },
        delivered: {
            label: 'Delivered',
            color: 'bg-green-100 text-green-800 border-green-200',
        },
        cancelled: {
            label: 'Cancelled',
            color: 'bg-red-100 text-red-800 border-red-200',
        },
    };

    const config = statusConfig[
        status.toLowerCase() as keyof typeof statusConfig
    ] || { label: status, color: 'bg-gray-100 text-gray-800 border-gray-200' };

    return <Badge className={config.color}>{config.label}</Badge>;
};

// Order Header
const OrderHeader = ({ order }: { order: Order }) => {
    return (
        <div className="space-y-4">
            <div className="flex items-start justify-between">
                <div className="space-y-2">
                    <h1 className="text-2xl font-bold">Order #{order.id}</h1>
                    <div className="flex items-center gap-4 text-sm text-muted-foreground">
                        <div className="flex items-center gap-2">
                            <Calendar className="h-4 w-4" />
                            <span>{formatDate(order.created_at)}</span>
                        </div>
                        <span>•</span>
                        <OrderStatusBadge status={order.status} />
                    </div>
                </div>
                <div className="text-right">
                    <div className="text-2xl font-bold text-green-600">
                        {formatCurrency(parseFloat(order.total))}
                    </div>
                    <div className="text-sm text-muted-foreground">
                        Total Amount
                    </div>
                </div>
            </div>
        </div>
    );
};

// Customer Information
const CustomerInfo = ({ order }: { order: Order }) => {
    const profileUrl = order.user.profile
        ? `/storage/profiles/${order.user.profile}`
        : null;

    console.log('👤 Customer profile URL:', profileUrl);

    return (
        <Card>
            <CardContent className="p-6">
                <div className="mb-4 flex items-center gap-2">
                    <User className="h-5 w-5" />
                    <h3 className="text-lg font-semibold">
                        Customer Information
                    </h3>
                </div>

                <div className="flex items-start gap-4">
                    {profileUrl ? (
                        <img
                            src={profileUrl}
                            alt={`${order.user.first_name} ${order.user.last_name}`}
                            className="h-16 w-16 rounded-full border object-cover"
                            onError={(e) => {
                                console.log(
                                    '🚨 Customer image failed:',
                                    profileUrl,
                                );
                                e.currentTarget.style.display = 'none';
                            }}
                            onLoad={() =>
                                console.log(
                                    '✅ Customer image loaded:',
                                    profileUrl,
                                )
                            }
                        />
                    ) : null}

                    {!profileUrl && (
                        <div className="flex h-16 w-16 items-center justify-center rounded-full bg-muted text-lg font-medium">
                            {order.user.first_name[0].toUpperCase()}
                            {order.user.last_name[0].toUpperCase()}
                        </div>
                    )}

                    <div className="flex-1 space-y-2">
                        <div>
                            <div className="text-lg font-semibold">
                                {order.user.first_name} {order.user.last_name}
                            </div>
                            <div className="flex items-center gap-2 text-sm text-muted-foreground">
                                <Mail className="h-4 w-4" />
                                <span>{order.user.email}</span>
                            </div>
                        </div>

                        <div className="flex gap-4 text-sm">
                            <div>
                                <span className="font-medium">ID:</span>{' '}
                                <span>{order.user.id}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </CardContent>
        </Card>
    );
};

// Order Items
const OrderItems = ({ order }: { order: Order }) => {
    console.log('📋 Order items count:', order.items.length);

    return (
        <Card>
            <CardContent className="p-6">
                <div className="mb-4 flex items-center gap-2">
                    <Package className="h-5 w-5" />
                    <h3 className="text-lg font-semibold">
                        Order Items ({order.items.length})
                    </h3>
                </div>

                <div className="space-y-6">
                    {order.items.map((item, index) => (
                        <div
                            key={item.id}
                            className="flex gap-4 border-b pb-6 last:border-b-0"
                        >
                            {/* Product Image */}
                            <ProductImage item={item} />

                            {/* Product Details */}
                            <div className="min-w-0 flex-1">
                                <div className="flex flex-col justify-between gap-4 md:flex-row md:items-start">
                                    <div className="flex-1">
                                        <h4 className="text-lg font-semibold">
                                            {item.product.name}
                                        </h4>
                                        <div className="mt-1 flex items-center gap-4 text-sm text-muted-foreground">
                                            {item.size && (
                                                <span>
                                                    Size:{' '}
                                                    {item.size.toUpperCase()}
                                                </span>
                                            )}
                                            {item.color && (
                                                <span>Color: {item.color}</span>
                                            )}
                                            <span>Qty: {item.qty}</span>
                                        </div>

                                        {item.product.description && (
                                            <p className="mt-2 text-sm text-muted-foreground">
                                                {item.product.description}
                                            </p>
                                        )}

                                        <div className="mt-2 flex items-center gap-4 text-xs text-muted-foreground">
                                            <span>
                                                Product ID: {item.product.id}
                                            </span>
                                            <span>
                                                Variant ID:{' '}
                                                {item.product_variant.id}
                                            </span>
                                            <span>
                                                Stock:{' '}
                                                {item.product_variant.stock}
                                            </span>
                                        </div>
                                    </div>

                                    <div className="text-right">
                                        <div className="text-lg font-bold text-green-600">
                                            {formatCurrency(
                                                parseFloat(item.price),
                                            )}
                                        </div>
                                        <div className="text-sm text-muted-foreground">
                                            each
                                        </div>
                                        <div className="mt-1 text-lg font-semibold">
                                            Total:{' '}
                                            {formatCurrency(
                                                parseFloat(item.price) *
                                                    item.qty,
                                            )}
                                        </div>
                                    </div>
                                </div>

                                {/* Product Status */}
                                <div className="mt-3 flex items-center gap-4">
                                    {item.product.is_active ? (
                                        <Badge className="border-green-200 bg-green-100 text-green-800">
                                            <CheckCircle2 className="mr-1 h-3 w-3" />
                                            Active
                                        </Badge>
                                    ) : (
                                        <Badge className="border-red-200 bg-red-100 text-red-800">
                                            <AlertCircle className="mr-1 h-3 w-3" />
                                            Inactive
                                        </Badge>
                                    )}

                                    {item.product.new_arrival && (
                                        <Badge className="border-blue-200 bg-blue-100 text-blue-800">
                                            <Sparkles className="mr-1 h-3 w-3" />
                                            New Arrival
                                        </Badge>
                                    )}
                                </div>
                            </div>
                        </div>
                    ))}
                </div>

                {/* Order Summary */}
                <div className="mt-4 border-t pt-4">
                    <div className="flex items-center justify-between text-lg font-semibold">
                        <span>Total</span>
                        <span className="text-green-600">
                            {formatCurrency(parseFloat(order.total))}
                        </span>
                    </div>
                </div>
            </CardContent>
        </Card>
    );
};

// Shipping & Payment Info
const ShippingPaymentInfo = ({ order }: { order: Order }) => {
    const address = order.address[0];
    const payment = order.payment[0];

    return (
        <div className="grid gap-6 md:grid-cols-2">
            {/* Shipping Information */}
            <Card>
                <CardContent className="p-6">
                    <div className="mb-4 flex items-center gap-2">
                        <Truck className="h-5 w-5" />
                        <h3 className="text-lg font-semibold">
                            Shipping Information
                        </h3>
                    </div>

                    <div className="space-y-3">
                        <div>
                            <p className="mb-1 text-sm font-medium">
                                Shipping Method
                            </p>
                            <Badge variant="outline">
                                {order.shipping_method}
                            </Badge>
                        </div>

                        {address && (
                            <div>
                                <p className="mb-1 text-sm font-medium">
                                    Shipping Address
                                </p>
                                <div className="space-y-1 text-sm">
                                    <div>{address.address_line1}</div>
                                    {address.address_line2 && (
                                        <div>{address.address_line2}</div>
                                    )}
                                    <div>
                                        {address.city}, {address.state}{' '}
                                        {address.postal_code}
                                    </div>
                                    <div>{address.country}</div>
                                </div>
                            </div>
                        )}
                    </div>
                </CardContent>
            </Card>

            {/* Payment Information */}
            <Card>
                <CardContent className="p-6">
                    <div className="mb-4 flex items-center gap-2">
                        <CreditCard className="h-5 w-5" />
                        <h3 className="text-lg font-semibold">
                            Payment Information
                        </h3>
                    </div>

                    {payment ? (
                        <div className="space-y-3">
                            <div>
                                <p className="mb-1 text-sm font-medium">
                                    Payment Method
                                </p>
                                <Badge variant="outline">
                                    {payment.payment_method}
                                </Badge>
                            </div>

                            <div>
                                <p className="mb-1 text-sm font-medium">
                                    Payment Status
                                </p>
                                <Badge
                                    variant={
                                        payment.payment_status.toLowerCase() ===
                                        'paid'
                                            ? 'default'
                                            : 'destructive'
                                    }
                                    className={
                                        payment.payment_status.toLowerCase() ===
                                        'paid'
                                            ? 'border-green-200 bg-green-100 text-green-800'
                                            : 'border-red-200 bg-red-100 text-red-800'
                                    }
                                >
                                    {payment.payment_status}
                                </Badge>
                            </div>

                            {payment.payment_transaction_id && (
                                <div>
                                    <p className="mb-1 text-sm font-medium">
                                        Transaction ID
                                    </p>
                                    <p className="font-mono text-sm">
                                        {payment.payment_transaction_id}
                                    </p>
                                </div>
                            )}
                        </div>
                    ) : (
                        <p className="text-muted-foreground">
                            No payment information available
                        </p>
                    )}
                </CardContent>
            </Card>
        </div>
    );
};

// Main Component
export default function OrderDetails({ order }: OrderDetailsProps) {
    console.log('🚀 ORDER DETAILS COMPONENT RENDERED');
    console.log('📦 Full order data:', order);
    console.log(
        '🖼️ Checking first item images:',
        order.items[0]?.product_variant?.images,
    );

    return (
        <AppLayout breadcrumbs={breadcrumbs}>
            <Head title={`Order - Details`} />

            <SidebarInset>
                <div className="flex flex-1 flex-col gap-6 p-6">
                    <OrderHeader order={order} />

                    <div className="grid gap-6 lg:grid-cols-3">
                        {/* Main Content */}
                        <div className="space-y-6 lg:col-span-2">
                            <CustomerInfo order={order} />
                            <OrderItems order={order} />
                            <ShippingPaymentInfo order={order} />
                        </div>

                        {/* Sidebar */}
                        <div className="space-y-6">
                            {/* Quick Stats */}
                            <Card>
                                <CardContent className="p-6">
                                    <h3 className="mb-4 font-semibold">
                                        Order Summary
                                    </h3>
                                    <div className="space-y-3">
                                        <div className="flex justify-between">
                                            <span className="text-sm">
                                                Items
                                            </span>
                                            <span className="font-medium">
                                                {order.items.reduce(
                                                    (sum, item) =>
                                                        sum + item.qty,
                                                    0,
                                                )}
                                            </span>
                                        </div>
                                        <div className="flex justify-between">
                                            <span className="text-sm">
                                                Products
                                            </span>
                                            <span className="font-medium">
                                                {order.items.length}
                                            </span>
                                        </div>
                                        <div className="flex justify-between">
                                            <span className="text-sm">
                                                Shipping
                                            </span>
                                            <span className="font-medium">
                                                {order.shipping_method}
                                            </span>
                                        </div>
                                        <div className="border-t pt-2">
                                            <div className="flex justify-between font-semibold">
                                                <span>Total</span>
                                                <span className="text-green-600">
                                                    {formatCurrency(
                                                        parseFloat(order.total),
                                                    )}
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </CardContent>
                            </Card>
                        </div>
                    </div>
                </div>
            </SidebarInset>
        </AppLayout>
    );
}
