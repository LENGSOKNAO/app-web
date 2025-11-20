import {
    AlertDialog,
    AlertDialogAction,
    AlertDialogCancel,
    AlertDialogContent,
    AlertDialogDescription,
    AlertDialogFooter,
    AlertDialogHeader,
    AlertDialogTitle,
} from '@/components/ui/alert-dialog';
import AppLayout from '@/layouts/app-layout';
import { order } from '@/routes';
import { type BreadcrumbItem } from '@/types';
import { Head, router } from '@inertiajs/react';
import {
    ColumnDef,
    ColumnFiltersState,
    flexRender,
    getCoreRowModel,
    getFilteredRowModel,
    getPaginationRowModel,
    getSortedRowModel,
    SortingState,
    useReactTable,
    VisibilityState,
} from '@tanstack/react-table';
import {
    ArrowUpDown,
    Check,
    CheckCircle,
    ChevronDown,
    Clock,
    CreditCard,
    Image as ImageIcon,
    MapPin,
    MoreHorizontal,
    Package,
    User,
    X,
    XCircle,
} from 'lucide-react';
import * as React from 'react';

import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import {
    Card,
    CardAction,
    CardDescription,
    CardFooter,
    CardHeader,
    CardTitle,
} from '@/components/ui/card';
import { Checkbox } from '@/components/ui/checkbox';
import {
    DropdownMenu,
    DropdownMenuCheckboxItem,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuSeparator,
    DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { Input } from '@/components/ui/input';
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from '@/components/ui/select';
import {
    Table,
    TableBody,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
} from '@/components/ui/table';
import {
    IconChevronLeft,
    IconChevronRight,
    IconChevronsLeft,
    IconChevronsRight,
} from '@tabler/icons-react';

import { Label } from '@/components/ui/label';

const breadcrumbs: BreadcrumbItem[] = [{ title: 'Orders', href: order().url }];

export type Order = {
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
    items: {
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
    }[];
};

/* -------------------------------------------------------------------------- */
/*                                 COLUMNS                                    */
/* -------------------------------------------------------------------------- */
export const columns: ColumnDef<Order>[] = [
    /* ----- SELECT ----- */
    {
        id: 'select',
        header: ({ table }) => (
            <Checkbox
                checked={
                    table.getIsAllPageRowsSelected() ||
                    (table.getIsSomePageRowsSelected() && 'indeterminate')
                }
                onCheckedChange={(v) => table.toggleAllPageRowsSelected(!!v)}
                aria-label="Select all"
            />
        ),
        cell: ({ row }) => (
            <Checkbox
                checked={row.getIsSelected()}
                onCheckedChange={(v) => row.toggleSelected(!!v)}
                aria-label="Select row"
            />
        ),
        enableSorting: false,
        enableHiding: false,
    },

    /* ----- ID ----- */
    {
        accessorKey: 'id',
        header: ({ column }) => (
            <Button
                variant="ghost"
                onClick={() =>
                    column.toggleSorting(column.getIsSorted() === 'asc')
                }
            >
                ID
                <ArrowUpDown className="ml-2 h-4 w-4" />
            </Button>
        ),
        cell: ({ row }) => (
            <div className="font-medium">{row.getValue('id')}</div>
        ),
    },

    /* ----- CUSTOMER + AVATAR ----- */
    {
        accessorKey: 'user',
        header: () => (
            <div className="flex items-center gap-1">
                <User className="h-4 w-4" /> Customer
            </div>
        ),
        cell: ({ row }) => {
            const u = row.getValue('user') as Order['user'];
            const profileUrl = u.profile
                ? `http://localhost:8000/storage/profiles/${u.profile}`
                : null;

            return (
                <div className="flex items-center gap-3">
                    {profileUrl ? (
                        <img
                            src={profileUrl}
                            alt={`${u.first_name} ${u.last_name}`}
                            className="h-10 w-10 rounded-full border object-cover"
                            onError={(e) => {
                                e.currentTarget.src = '';
                            }}
                        />
                    ) : (
                        <div className="flex h-10 w-10 items-center justify-center rounded-full bg-muted text-xs font-medium">
                            {u.first_name[0].toUpperCase()}
                            {u.last_name[0].toUpperCase()}
                        </div>
                    )}
                    <div>
                        <div className="font-medium">
                            {u.first_name} {u.last_name}
                        </div>
                        <div className="text-sm text-muted-foreground">
                            {u.email}
                        </div>
                    </div>
                </div>
            );
        },
    },

    /* ----- PRODUCT IMAGES ----- */
    {
        accessorKey: 'items',
        header: () => (
            <div className="flex items-center gap-1">
                <ImageIcon className="h-4 w-4" /> Products
            </div>
        ),
        cell: ({ row }) => {
            const items = row.getValue('items') as Order['items'];

            const getProductImage = (item: Order['items'][0]) => {
                // Get image from product_variant.images array
                if (item.product_variant?.images?.length) {
                    // Try to find primary image first
                    const primaryImage = item.product_variant.images.find(
                        (img) => img.is_primary,
                    );
                    if (primaryImage) {
                        return `http://localhost:8000/storage/${primaryImage.image}`;
                    }
                    // Fallback to first image
                    return `http://localhost:8000/storage/${item.product_variant.images[0].image}`;
                }

                // Return null if no image found
                return null;
            };

            return (
                <div className="flex -space-x-2">
                    {items.slice(0, 3).map((item, index) => {
                        const imageUrl = getProductImage(item);
                        return (
                            <div
                                key={item.id}
                                className="relative"
                                title={`${item.product.name} (${item.size}, ${item.color})`}
                            >
                                {imageUrl ? (
                                    <img
                                        src={imageUrl}
                                        alt={item.product.name}
                                        className="h-10 w-10 rounded-lg border-2 border-background object-cover shadow-sm"
                                        onError={(e) => {
                                            // If image fails to load, show placeholder
                                            e.currentTarget.style.display =
                                                'none';
                                        }}
                                    />
                                ) : (
                                    <div className="flex h-10 w-10 items-center justify-center rounded-lg border-2 border-background bg-muted shadow-sm">
                                        <ImageIcon className="h-4 w-4 text-muted-foreground" />
                                    </div>
                                )}
                                {item.qty > 1 && (
                                    <Badge
                                        variant="secondary"
                                        className="absolute -top-1 -right-1 h-4 min-w-4 px-1 text-xs"
                                    >
                                        {item.qty}
                                    </Badge>
                                )}
                            </div>
                        );
                    })}
                    {items.length > 3 && (
                        <div className="flex h-10 w-10 items-center justify-center rounded-lg border-2 border-background bg-muted text-xs font-medium shadow-sm">
                            +{items.length - 3}
                        </div>
                    )}
                </div>
            );
        },
    },
    /* ----- PRODUCT DETAILS ----- */
    {
        accessorKey: 'items',
        header: () => <div>Products</div>,
        cell: ({ row }) => {
            const items = row.getValue('items') as Order['items'];
            return (
                <div className="max-w-[200px]">
                    <div className="space-y-1">
                        {items.map((item, index) => (
                            <div
                                key={item.id}
                                className="flex items-start gap-1 text-sm"
                            >
                                <span className="mt-0.5 text-xs text-muted-foreground">
                                    {index + 1}.
                                </span>
                                <div className="flex-1">
                                    <div className="font-medium">
                                        {item.product.name}
                                    </div>
                                    <div className="text-xs text-muted-foreground">
                                        {item.size &&
                                            `${item.size.toUpperCase()}`}
                                        {item.size && item.color && '/'}
                                        {item.color && `${item.color}`}
                                        {item.qty > 1 && ` × ${item.qty}`}
                                    </div>
                                </div>
                                <div className="text-xs font-semibold whitespace-nowrap text-green-600">
                                    ${parseFloat(item.price).toFixed(2)}
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            );
        },
    },

    /* ----- ADDRESS ----- */
    {
        accessorKey: 'address',
        header: () => (
            <div className="flex items-center gap-1">
                <MapPin className="h-4 w-4" /> Address
            </div>
        ),
        cell: ({ row }) => {
            const addr = (row.getValue('address') as Order['address'])[0];
            if (!addr) return <span className="text-muted-foreground">—</span>;
            return (
                <div className="max-w-[150px]">
                    <div className="truncate text-sm">{addr.address_line1}</div>
                    <div className="text-xs text-muted-foreground">
                        {addr.city}, {addr.country}
                    </div>
                </div>
            );
        },
    },

    /* ----- PAYMENT METHOD ----- */
    {
        accessorKey: 'payment',
        header: () => (
            <div className="flex items-center gap-1">
                <CreditCard className="h-4 w-4" /> Payment
            </div>
        ),
        cell: ({ row }) => {
            const pay = (row.getValue('payment') as Order['payment'])[0];
            if (!pay) return <span className="text-muted-foreground">—</span>;
            return (
                <div>
                    <div className="text-sm font-medium">
                        {pay.payment_method}
                    </div>
                    <div
                        className={
                            pay.payment_status.toLowerCase() === 'paid'
                                ? 'text-xs text-green-600'
                                : 'text-xs text-red-600'
                        }
                    >
                        {pay.payment_status}
                    </div>
                </div>
            );
        },
    },

    /* ----- SHIPPING (EDITABLE) ----- */
    {
        accessorKey: 'shipping_method',
        header: () => (
            <div className="flex items-center gap-1">
                <Package className="h-4 w-4" /> Shipping
            </div>
        ),
        cell: ({ row }) => {
            const order = row.original;
            const [editing, setEditing] = React.useState(false);
            const [value, setValue] = React.useState(order.shipping_method);
            const original = order.shipping_method;

            const options = [
                'Standard',
                'Express',
                'Overnight',
                'Pickup at Store',
            ] as const;

            const handleSave = () => {
                const formData = new FormData();
                formData.append('shipping_method', value);
                formData.append('_method', 'PUT');

                router.post(`/order/${order.id}`, formData, {
                    preserveState: true,
                    onFinish: () => setEditing(false),
                    onError: () => {
                        setValue(original);
                        setEditing(false);
                    },
                });
            };

            if (!editing) {
                return (
                    <Button
                        variant="ghost"
                        size="sm"
                        className="h-7 px-2 text-xs"
                        onClick={() => setEditing(true)}
                    >
                        {value || '—'}
                    </Button>
                );
            }

            return (
                <div className="flex items-center gap-1">
                    <Select value={value} onValueChange={setValue}>
                        <SelectTrigger className="h-8 w-28 text-xs">
                            <SelectValue />
                        </SelectTrigger>
                        <SelectContent>
                            {options.map((opt) => (
                                <SelectItem key={opt} value={opt}>
                                    {opt}
                                </SelectItem>
                            ))}
                        </SelectContent>
                    </Select>
                    <Button
                        variant="ghost"
                        size="icon"
                        className="h-7 w-7"
                        onClick={handleSave}
                    >
                        <Check className="h-4 w-4 text-green-600" />
                    </Button>
                    <Button
                        variant="ghost"
                        size="icon"
                        className="h-7 w-7"
                        onClick={() => {
                            setValue(original);
                            setEditing(false);
                        }}
                    >
                        <X className="h-4 w-4 text-red-600" />
                    </Button>
                </div>
            );
        },
    },

    /* ----- TOTAL AMOUNT ----- */
    {
        accessorKey: 'total',
        header: () => <div>Amount</div>,
        cell: ({ row }) => {
            const total = parseFloat(row.getValue('total') as string) || 0;
            return (
                <div className="font-bold text-green-600">
                    ${total.toFixed(2)}
                </div>
            );
        },
    },

    /* ----- ITEM COUNT ----- */
    {
        accessorKey: 'items',
        header: () => <div>Items</div>,
        cell: ({ row }) => {
            const items = row.getValue('items') as Order['items'];
            const totalItems = items.reduce((sum, item) => sum + item.qty, 0);
            return <div className="text-center font-medium">{totalItems}</div>;
        },
    },

    /* ----- STATUS (EDITABLE) ----- */
    {
        accessorKey: 'status',
        header: () => <div>Status</div>,
        cell: ({ row }) => {
            const order = row.original;
            const [editing, setEditing] = React.useState(false);
            const [value, setValue] = React.useState(order.status);
            const original = order.status;

            const options = [
                'Pending',
                'Processing',
                'Shipped',
                'Delivered',
                'Cancelled',
            ] as const;

            const handleSave = () => {
                const formData = new FormData();
                formData.append('status', value);
                formData.append('_method', 'PUT');

                router.post(`/order/${order.id}`, formData, {
                    preserveState: true,
                    onFinish: () => setEditing(false),
                    onError: () => {
                        setValue(original);
                        setEditing(false);
                    },
                });
            };

            const colorMap: Record<string, string> = {
                Pending: 'text-yellow-600',
                Processing: 'text-blue-600',
                Shipped: 'text-purple-600',
                Delivered: 'text-green-600',
                Cancelled: 'text-red-600',
            };

            const color = colorMap[value] || 'text-muted-foreground';

            if (!editing) {
                return (
                    <Button
                        variant="ghost"
                        size="sm"
                        className={`h-7 px-2 text-xs font-medium ${color}`}
                        onClick={() => setEditing(true)}
                    >
                        {value}
                    </Button>
                );
            }

            return (
                <div className="flex items-center gap-1">
                    <Select value={value} onValueChange={setValue}>
                        <SelectTrigger className="h-8 w-32 text-xs">
                            <SelectValue />
                        </SelectTrigger>
                        <SelectContent>
                            {options.map((opt) => (
                                <SelectItem key={opt} value={opt}>
                                    {opt}
                                </SelectItem>
                            ))}
                        </SelectContent>
                    </Select>
                    <Button
                        variant="ghost"
                        size="icon"
                        className="h-7 w-7"
                        onClick={handleSave}
                    >
                        <Check className="h-4 w-4 text-green-600" />
                    </Button>
                    <Button
                        variant="ghost"
                        size="icon"
                        className="h-7 w-7"
                        onClick={() => {
                            setValue(original);
                            setEditing(false);
                        }}
                    >
                        <X className="h-4 w-4 text-red-600" />
                    </Button>
                </div>
            );
        },
    },

    /* ----- CREATED AT ----- */
    {
        accessorKey: 'created_at',
        header: () => (
            <div className="flex items-center gap-1">
                <Clock className="h-4 w-4" /> Created
            </div>
        ),
        cell: ({ row }) => {
            const date = new Date(row.getValue('created_at') as string);
            return (
                <div className="text-sm">
                    {date.toLocaleDateString('en-US', {
                        month: 'short',
                        day: 'numeric',
                        year: 'numeric',
                    })}
                </div>
            );
        },
    },

    /* ----- ACTIONS ----- */
    {
        id: 'actions',
        header: () => <div className="sr-only">Actions</div>,
        cell: ({ row }) => {
            const order = row.original;
            const [open, setOpen] = React.useState(false);

            const handleDelete = () => {
                router.delete(`/order/${order.id}`, {
                    onSuccess: () => setOpen(false),
                });
            };

            return (
                <>
                    <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                            <Button variant="ghost" className="h-8 w-8 p-0">
                                <span className="sr-only">Open menu</span>
                                <MoreHorizontal className="h-4 w-4" />
                            </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="end">
                            <DropdownMenuLabel>Actions</DropdownMenuLabel>
                            <DropdownMenuItem asChild>
                                <a href={`/order/${order.id}`}>View Details</a>
                            </DropdownMenuItem>
                            <DropdownMenuSeparator />
                            <DropdownMenuItem
                                className="text-red-600 focus:text-red-600"
                                onSelect={(e) => e.preventDefault()}
                                onClick={() => setOpen(true)}
                            >
                                Delete Order
                            </DropdownMenuItem>
                        </DropdownMenuContent>
                    </DropdownMenu>

                    <AlertDialog open={open} onOpenChange={setOpen}>
                        <AlertDialogContent>
                            <AlertDialogHeader>
                                <AlertDialogTitle>
                                    Delete Order?
                                </AlertDialogTitle>
                                <AlertDialogDescription>
                                    This action cannot be undone. This will
                                    permanently delete the order.
                                </AlertDialogDescription>
                            </AlertDialogHeader>
                            <AlertDialogFooter>
                                <AlertDialogCancel>Cancel</AlertDialogCancel>
                                <AlertDialogAction onClick={handleDelete}>
                                    Delete
                                </AlertDialogAction>
                            </AlertDialogFooter>
                        </AlertDialogContent>
                    </AlertDialog>
                </>
            );
        },
    },
];
 
export default function OrdersPage({ order }: { order: Order[] }) {
    const [sorting, setSorting] = React.useState<SortingState>([]);
    const [columnFilters, setColumnFilters] =
        React.useState<ColumnFiltersState>([]);
    const [columnVisibility, setColumnVisibility] =
        React.useState<VisibilityState>({});
    const [rowSelection, setRowSelection] = React.useState({});
    const [globalFilter, setGlobalFilter] = React.useState('');

    const table = useReactTable({
        data: order,
        columns,
        onSortingChange: setSorting,
        onColumnFiltersChange: setColumnFilters,
        onGlobalFilterChange: setGlobalFilter,
        getCoreRowModel: getCoreRowModel(),
        getPaginationRowModel: getPaginationRowModel(),
        getSortedRowModel: getSortedRowModel(),
        getFilteredRowModel: getFilteredRowModel(),
        onColumnVisibilityChange: setColumnVisibility,
        onRowSelectionChange: setRowSelection,
        globalFilterFn: 'includesString',
        state: {
            sorting,
            columnFilters,
            columnVisibility,
            rowSelection,
            globalFilter,
        },
    });

    const rows = table.getFilteredRowModel().rows;
    const total = rows.length;

    const statusCounts = rows.reduce(
        (acc, r) => {
            const s = (r.original.status || '').toLowerCase();
            acc[s] = (acc[s] || 0) + 1;
            return acc;
        },
        {} as Record<string, number>,
    );

    return (
        <AppLayout breadcrumbs={breadcrumbs}>
            <Head title="Orders" />
            <div className="flex h-full flex-1 flex-col gap-6 overflow-x-auto rounded-xl p-6">
                {/* ---------- 4 STAT CARDS ---------- */}
                <div className="grid grid-cols-1 gap-4 *:data-[slot=card]:bg-gradient-to-t *:data-[slot=card]:from-primary/5 *:data-[slot=card]:to-card *:data-[slot=card]:shadow-xs sm:grid-cols-2 xl:grid-cols-4 @xl/main:grid-cols-2 @5xl/main:grid-cols-4 dark:*:data-[slot=card]:bg-card">
                    {/* Total */}
                    <Card className="@container/card">
                        <CardHeader>
                            <CardDescription>Total Orders</CardDescription>
                            <CardTitle className="text-2xl font-semibold tabular-nums @[250px]/card:text-3xl">
                                {total.toLocaleString()}
                            </CardTitle>
                            <CardAction>
                                <Badge variant="outline">
                                    <Package className="size-4" />
                                    {total.toLocaleString()}
                                </Badge>
                            </CardAction>
                        </CardHeader>
                        <CardFooter className="flex-col items-start gap-1.5 text-sm">
                            <div className="line-clamp-1 flex gap-2 font-medium">
                                All orders in system{' '}
                                <Package className="size-4" />
                            </div>
                            <div className="text-muted-foreground">
                                Total orders processed
                            </div>
                        </CardFooter>
                    </Card>

                    {/* Delivered */}
                    <Card className="@container/card">
                        <CardHeader>
                            <CardDescription>Delivered</CardDescription>
                            <CardTitle className="text-2xl font-semibold tabular-nums @[250px]/card:text-3xl">
                                {(
                                    statusCounts['delivered'] ?? 0
                                ).toLocaleString()}
                            </CardTitle>
                            <CardAction>
                                <Badge variant="outline">
                                    <CheckCircle className="size-4" />
                                    {(
                                        statusCounts['delivered'] ?? 0
                                    ).toLocaleString()}
                                </Badge>
                            </CardAction>
                        </CardHeader>
                        <CardFooter className="flex-col items-start gap-1.5 text-sm">
                            <div className="line-clamp-1 flex gap-2 font-medium">
                                Completed orders{' '}
                                <CheckCircle className="size-4" />
                            </div>
                            <div className="text-muted-foreground">
                                {total > 0
                                    ? (
                                          ((statusCounts['delivered'] ?? 0) /
                                              total) *
                                          100
                                      ).toFixed(1)
                                    : 0}
                                % of total
                            </div>
                        </CardFooter>
                    </Card>

                    {/* Processing */}
                    <Card className="@container/card">
                        <CardHeader>
                            <CardDescription>Processing</CardDescription>
                            <CardTitle className="text-2xl font-semibold tabular-nums @[250px]/card:text-3xl">
                                {(
                                    (statusCounts['pending'] ?? 0) +
                                    (statusCounts['processing'] ?? 0)
                                ).toLocaleString()}
                            </CardTitle>
                            <CardAction>
                                <Badge variant="outline">
                                    <Clock className="size-4" />
                                    {(
                                        (statusCounts['pending'] ?? 0) +
                                        (statusCounts['processing'] ?? 0)
                                    ).toLocaleString()}
                                </Badge>
                            </CardAction>
                        </CardHeader>
                        <CardFooter className="flex-col items-start gap-1.5 text-sm">
                            <div className="line-clamp-1 flex gap-2 font-medium">
                                In progress <Clock className="size-4" />
                            </div>
                            <div className="text-muted-foreground">
                                {total > 0
                                    ? (
                                          (((statusCounts['pending'] ?? 0) +
                                              (statusCounts['processing'] ??
                                                  0)) /
                                              total) *
                                          100
                                      ).toFixed(1)
                                    : 0}
                                % of total
                            </div>
                        </CardFooter>
                    </Card>

                    {/* Cancelled */}
                    <Card className="@container/card">
                        <CardHeader>
                            <CardDescription>Cancelled</CardDescription>
                            <CardTitle className="text-2xl font-semibold tabular-nums @[250px]/card:text-3xl">
                                {(
                                    statusCounts['cancelled'] ?? 0
                                ).toLocaleString()}
                            </CardTitle>
                            <CardAction>
                                <Badge variant="outline">
                                    <XCircle className="size-4" />
                                    {(
                                        statusCounts['cancelled'] ?? 0
                                    ).toLocaleString()}
                                </Badge>
                            </CardAction>
                        </CardHeader>
                        <CardFooter className="flex-col items-start gap-1.5 text-sm">
                            <div className="line-clamp-1 flex gap-2 font-medium">
                                Cancelled orders <XCircle className="size-4" />
                            </div>
                            <div className="text-muted-foreground">
                                {total > 0
                                    ? (
                                          ((statusCounts['cancelled'] ?? 0) /
                                              total) *
                                          100
                                      ).toFixed(1)
                                    : 0}
                                % of total
                            </div>
                        </CardFooter>
                    </Card>
                </div>

                {/* ---------- TABLE ---------- */}
                <div className="rounded-xl border bg-card shadow-sm">
                    <div className="flex flex-col gap-4 p-6 pb-4 md:flex-row md:items-center md:justify-between">
                        <Input
                            placeholder="Search by ID, name, email, product..."
                            value={globalFilter ?? ''}
                            onChange={(e) => setGlobalFilter(e.target.value)}
                            className="w-full sm:max-w-sm"
                        />
                        <DropdownMenu>
                            <DropdownMenuTrigger asChild>
                                <Button variant="outline" size="sm">
                                    Columns{' '}
                                    <ChevronDown className="ml-2 h-4 w-4" />
                                </Button>
                            </DropdownMenuTrigger>
                            <DropdownMenuContent align="end">
                                {table
                                    .getAllColumns()
                                    .filter((column) => column.getCanHide())
                                    .map((column) => (
                                        <DropdownMenuCheckboxItem
                                            key={column.id}
                                            className="capitalize"
                                            checked={column.getIsVisible()}
                                            onCheckedChange={(value) =>
                                                column.toggleVisibility(!!value)
                                            }
                                        >
                                            {column.id === 'user.role'
                                                ? 'Role'
                                                : column.id === 'items'
                                                  ? 'Product Images'
                                                  : column.id}
                                        </DropdownMenuCheckboxItem>
                                    ))}
                            </DropdownMenuContent>
                        </DropdownMenu>
                    </div>

                    <div className="overflow-x-auto">
                        <Table>
                            <TableHeader>
                                {table.getHeaderGroups().map((headerGroup) => (
                                    <TableRow key={headerGroup.id}>
                                        {headerGroup.headers.map((header) => (
                                            <TableHead key={header.id}>
                                                {header.isPlaceholder
                                                    ? null
                                                    : flexRender(
                                                          header.column
                                                              .columnDef.header,
                                                          header.getContext(),
                                                      )}
                                            </TableHead>
                                        ))}
                                    </TableRow>
                                ))}
                            </TableHeader>
                            <TableBody>
                                {table.getRowModel().rows?.length ? (
                                    table.getRowModel().rows.map((row) => (
                                        <TableRow
                                            key={row.id}
                                            data-state={
                                                row.getIsSelected() &&
                                                'selected'
                                            }
                                        >
                                            {row
                                                .getVisibleCells()
                                                .map((cell) => (
                                                    <TableCell key={cell.id}>
                                                        {flexRender(
                                                            cell.column
                                                                .columnDef.cell,
                                                            cell.getContext(),
                                                        )}
                                                    </TableCell>
                                                ))}
                                        </TableRow>
                                    ))
                                ) : (
                                    <TableRow>
                                        <TableCell
                                            colSpan={columns.length}
                                            className="h-24 text-center"
                                        >
                                            No orders found.
                                        </TableCell>
                                    </TableRow>
                                )}
                            </TableBody>
                        </Table>
                    </div>
                    <div className="flex items-center justify-between px-6 py-4">
                        <div className="hidden flex-1 text-sm text-muted-foreground lg:flex">
                            {table.getFilteredSelectedRowModel().rows.length} of{' '}
                            {table.getFilteredRowModel().rows.length} row(s)
                            selected.
                        </div>
                        <div className="flex w-full items-center gap-8 lg:w-fit">
                            <div className="hidden items-center gap-2 lg:flex">
                                <Label
                                    htmlFor="rows-per-page"
                                    className="text-sm font-medium"
                                >
                                    Rows per page
                                </Label>
                                <Select
                                    value={`${table.getState().pagination.pageSize}`}
                                    onValueChange={(value) => {
                                        table.setPageSize(Number(value));
                                    }}
                                >
                                    <SelectTrigger
                                        size="sm"
                                        className="w-20"
                                        id="rows-per-page"
                                    >
                                        <SelectValue
                                            placeholder={
                                                table.getState().pagination
                                                    .pageSize
                                            }
                                        />
                                    </SelectTrigger>
                                    <SelectContent side="top">
                                        {[10, 20, 30, 40, 50].map(
                                            (pageSize) => (
                                                <SelectItem
                                                    key={pageSize}
                                                    value={`${pageSize}`}
                                                >
                                                    {pageSize}
                                                </SelectItem>
                                            ),
                                        )}
                                    </SelectContent>
                                </Select>
                            </div>
                            <div className="flex w-fit items-center justify-center text-sm font-medium">
                                Page {table.getState().pagination.pageIndex + 1}{' '}
                                of {table.getPageCount()}
                            </div>
                            <div className="ml-auto flex items-center gap-2 lg:ml-0">
                                <Button
                                    variant="outline"
                                    className="hidden h-8 w-8 p-0 lg:flex"
                                    onClick={() => table.setPageIndex(0)}
                                    disabled={!table.getCanPreviousPage()}
                                >
                                    <span className="sr-only">
                                        Go to first page
                                    </span>
                                    <IconChevronsLeft />
                                </Button>
                                <Button
                                    variant="outline"
                                    className="size-8"
                                    size="icon"
                                    onClick={() => table.previousPage()}
                                    disabled={!table.getCanPreviousPage()}
                                >
                                    <span className="sr-only">
                                        Go to previous page
                                    </span>
                                    <IconChevronLeft />
                                </Button>
                                <Button
                                    variant="outline"
                                    className="size-8"
                                    size="icon"
                                    onClick={() => table.nextPage()}
                                    disabled={!table.getCanNextPage()}
                                >
                                    <span className="sr-only">
                                        Go to next page
                                    </span>
                                    <IconChevronRight />
                                </Button>
                                <Button
                                    variant="outline"
                                    className="hidden size-8 lg:flex"
                                    size="icon"
                                    onClick={() =>
                                        table.setPageIndex(
                                            table.getPageCount() - 1,
                                        )
                                    }
                                    disabled={!table.getCanNextPage()}
                                >
                                    <span className="sr-only">
                                        Go to last page
                                    </span>
                                    <IconChevronsRight />
                                </Button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </AppLayout>
    );
}
