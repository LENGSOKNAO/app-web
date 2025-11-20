'use client';

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
import { product } from '@/routes';
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
    Boxes,
    CheckCircle,
    ChevronDown,
    MoreHorizontal,
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
import { Label } from '@/components/ui/label';
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
    Tooltip,
    TooltipContent,
    TooltipTrigger,
} from '@/components/ui/tooltip';
import {
    IconChevronLeft,
    IconChevronRight,
    IconChevronsLeft,
    IconChevronsRight,
    IconTrendingUp,
} from '@tabler/icons-react';

/* -------------------------------------------------------------------------- */
/*                               BREADCRUMBS                                  */
/* -------------------------------------------------------------------------- */
const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Products', href: product().url },
];

/* -------------------------------------------------------------------------- */
/*                                 TYPE (REAL)                                */
/* -------------------------------------------------------------------------- */
export type Products = {
    id: number;
    name: string;
    description: string;
    is_active: boolean;
    new_arrival: boolean;
    date_added: string;
    brand: { brand_name: string }[];
    category: { category_name: string }[];
    tax: { tax: number }[];
    varants: {
        id: number;
        sizes: string;
        colors: string;
        price: number;
        stock: number;
        images: { image: string }[];
    }[];
    coupons: {
        code: string;
        discount_amount: number;
        start_date: string;
        end_date: string;
    }[];
    created_at: string;
    updated_at: string;
};

/* -------------------------------------------------------------------------- */
/*                                 COLUMNS                                    */
/* -------------------------------------------------------------------------- */
export const columns: ColumnDef<Products>[] = [
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
        enableGlobalFilter: false,
    },

    /* ----- NAME ----- */
    {
        accessorKey: 'name',
        header: ({ column }) => (
            <Button
                variant="ghost"
                onClick={() =>
                    column.toggleSorting(column.getIsSorted() === 'asc')
                }
            >
                Name
                <ArrowUpDown className="ml-2 h-4 w-4" />
            </Button>
        ),
        cell: ({ row }) => <div>{row.getValue('name') || 'No name'}</div>,
        enableGlobalFilter: true,
        filterFn: (row, id, filter) => {
            const v = row.getValue(id) as string;
            return v.toLowerCase().includes(filter.toLowerCase());
        },
    },

    /* ----- DESCRIPTION ----- */
    {
        accessorKey: 'description',
        header: () => <div>Description</div>,
        cell: ({ row }) => (
            <div className="max-w-[200px] truncate">
                {row.getValue('description') || 'No Description'}
            </div>
        ),
        enableGlobalFilter: true,
        filterFn: (row, id, filter) => {
            const v = row.getValue(id) as string;
            return v.toLowerCase().includes(filter.toLowerCase());
        },
    },

    /* ----- BRAND ----- */
    {
        accessorKey: 'brand',
        header: () => <div>Brand</div>,
        cell: ({ row }) => {
            const brands = row.getValue('brand') as { brand_name: string }[];
            return (
                <div>
                    {brands?.length
                        ? brands.map((b) => b.brand_name).join(', ')
                        : 'No Brand'}
                </div>
            );
        },
        enableGlobalFilter: true,
        filterFn: (row, id, filter) => {
            const brands = row.getValue(id) as { brand_name: string }[];
            if (!brands?.length) return false;
            const s = filter.toLowerCase();
            return brands.some((b) => b.brand_name.toLowerCase().includes(s));
        },
    },

    /* ----- CATEGORY ----- */
    {
        accessorKey: 'category',
        header: () => <div>Category</div>,
        cell: ({ row }) => {
            const cats = row.getValue('category') as {
                category_name: string;
            }[];
            return (
                <div>
                    {cats?.length
                        ? cats.map((c) => c.category_name).join(', ')
                        : 'No Category'}
                </div>
            );
        },
        enableGlobalFilter: true,
        filterFn: (row, id, filter) => {
            const cats = row.getValue(id) as { category_name: string }[];
            if (!cats?.length) return false;
            const s = filter.toLowerCase();
            return cats.some((c) => c.category_name.toLowerCase().includes(s));
        },
    },

    /* ----- TAX ----- */
    {
        accessorKey: 'tax',
        header: () => <div>Tax</div>,
        cell: ({ row }) => {
            const taxes = row.getValue('tax') as { tax: number }[];
            return (
                <div>
                    {taxes?.length
                        ? taxes.map((t) => `${t.tax}%`).join(', ')
                        : 'No tax'}
                </div>
            );
        },
        enableGlobalFilter: true,
        filterFn: (row, id, filter) => {
            const taxes = row.getValue(id) as { tax: number }[];
            if (!taxes?.length) return false;
            const s = filter.toLowerCase();
            return taxes.some((t) => String(t.tax).includes(s));
        },
    },

    /* ----- VARIANTS – SIZES ----- */
    {
        accessorKey: 'varants',
        header: () => <div>Sizes</div>,
        cell: ({ row }) => {
            const v = row.getValue('varants') as any[];
            const sizes = v?.map((x) => x.sizes).filter(Boolean) ?? [];
            return <div>{sizes.length ? sizes.join(', ') : 'No sizes'}</div>;
        },
        enableGlobalFilter: true,
        filterFn: (row, id, filter) => {
            const v = row.getValue(id) as any[];
            if (!v?.length) return false;
            const s = filter.toLowerCase();
            return v.some((x) => x.sizes?.toLowerCase().includes(s));
        },
    },

    /* ----- VARIANTS – COLORS ----- */
    {
        accessorKey: 'varants',
        header: () => <div>Colors</div>,
        cell: ({ row }) => {
            const v = row.getValue('varants') as any[];
            const colors = v?.map((x) => x.colors).filter(Boolean) ?? [];
            return <div>{colors.length ? colors.join(', ') : 'No colors'}</div>;
        },
        enableGlobalFilter: true,
        filterFn: (row, id, filter) => {
            const v = row.getValue(id) as any[];
            if (!v?.length) return false;
            const s = filter.toLowerCase();
            return v.some((x) => x.colors?.toLowerCase().includes(s));
        },
    },

    /* ----- VARIANTS – PRICE ----- */
    {
        accessorKey: 'varants',
        header: () => <div>Price</div>,
        cell: ({ row }) => {
            const v = row.getValue('varants') as any[];
            const prices = v?.map((x) => x.price).filter(Boolean) ?? [];
            return (
                <div>
                    {prices.length
                        ? prices.map((p) => `$${p}`).join(', ')
                        : 'No price'}
                </div>
            );
        },
        enableGlobalFilter: true,
        filterFn: (row, id, filter) => {
            const v = row.getValue(id) as any[];
            if (!v?.length) return false;
            const s = filter.toLowerCase();
            return v.some((x) => String(x.price).includes(s));
        },
    },

    /* ----- VARIANTS – STOCK ----- */
    {
        accessorKey: 'varants',
        header: () => <div>Stock</div>,
        cell: ({ row }) => {
            const v = row.getValue('varants') as any[];
            const stocks = v?.map((x) => x.stock).filter(Boolean) ?? [];
            return <div>{stocks.length ? stocks.join(', ') : 'No stock'}</div>;
        },
        enableGlobalFilter: true,
        filterFn: (row, id, filter) => {
            const v = row.getValue(id) as any[];
            if (!v?.length) return false;
            const s = filter.toLowerCase();
            return v.some((x) => String(x.stock).includes(s));
        },
    },

    /* ----- COUPONS – CODE ----- */
    {
        accessorKey: 'coupons',
        header: () => <div>Code</div>,
        cell: ({ row }) => {
            const c = row.getValue('coupons') as { code: string }[];
            return (
                <div>
                    {c?.length ? c.map((x) => x.code).join(', ') : 'No code'}
                </div>
            );
        },
        enableGlobalFilter: true,
        filterFn: (row, id, filter) => {
            const c = row.getValue(id) as { code: string }[];
            if (!c?.length) return false;
            const s = filter.toLowerCase();
            return c.some((x) => x.code.toLowerCase().includes(s));
        },
    },

    /* ----- COUPONS – DISCOUNT ----- */
    {
        accessorKey: 'coupons',
        header: () => <div>Discount</div>,
        cell: ({ row }) => {
            const c = row.getValue('coupons') as { discount_amount: number }[];
            return (
                <div>
                    {c?.length
                        ? c.map((x) => `$${x.discount_amount}`).join(', ')
                        : 'No discount'}
                </div>
            );
        },
        enableGlobalFilter: true,
        filterFn: (row, id, filter) => {
            const c = row.getValue(id) as { discount_amount: number }[];
            if (!c?.length) return false;
            const s = filter.toLowerCase();
            return c.some((x) => String(x.discount_amount).includes(s));
        },
    },

    /* ----- COUPONS – START DATE ----- */
    {
        accessorKey: 'coupons',
        header: () => <div>Start Date</div>,
        cell: ({ row }) => {
            const c = row.getValue('coupons') as { start_date: string }[];
            return (
                <div>
                    {c?.length
                        ? c
                              .map((x) =>
                                  new Date(x.start_date).toLocaleDateString(),
                              )
                              .join(', ')
                        : 'No start date'}
                </div>
            );
        },
        enableGlobalFilter: true,
        filterFn: (row, id, filter) => {
            const c = row.getValue(id) as { start_date: string }[];
            if (!c?.length) return false;
            const s = filter.toLowerCase();
            return c.some((x) =>
                new Date(x.start_date)
                    .toLocaleDateString()
                    .toLowerCase()
                    .includes(s),
            );
        },
    },

    /* ----- COUPONS – END DATE ----- */
    {
        accessorKey: 'coupons',
        header: () => <div>End Date</div>,
        cell: ({ row }) => {
            const c = row.getValue('coupons') as { end_date: string }[];
            return (
                <div>
                    {c?.length
                        ? c
                              .map((x) =>
                                  new Date(x.end_date).toLocaleDateString(),
                              )
                              .join(', ')
                        : 'No end date'}
                </div>
            );
        },
        enableGlobalFilter: true,
        filterFn: (row, id, filter) => {
            const c = row.getValue(id) as { end_date: string }[];
            if (!c?.length) return false;
            const s = filter.toLowerCase();
            return c.some((x) =>
                new Date(x.end_date)
                    .toLocaleDateString()
                    .toLowerCase()
                    .includes(s),
            );
        },
    },

    /* ----- NEW ARRIVAL ----- */
    {
        accessorKey: 'new_arrival',
        header: () => <div>Arrival</div>,
        cell: ({ row }) => (
            <div
                className={
                    row.getValue('new_arrival')
                        ? 'text-green-600'
                        : 'text-gray-500'
                }
            >
                {row.getValue('new_arrival') ? 'New' : 'Old'}
            </div>
        ),
        enableGlobalFilter: true,
        filterFn: (row, id, filter) => {
            const v = row.getValue(id) as boolean;
            const s = filter.toLowerCase();
            if (s === 'new') return v === true;
            if (s === 'old') return v === false;
            return true;
        },
    },

    /* ----- IS ACTIVE ----- */
    {
        accessorKey: 'is_active',
        header: () => <div>Status</div>,
        cell: ({ row }) => (
            <div
                className={
                    row.getValue('is_active')
                        ? 'text-green-600'
                        : 'text-red-600'
                }
            >
                {row.getValue('is_active') ? 'Active' : 'Inactive'}
            </div>
        ),
        enableGlobalFilter: true,
        filterFn: (row, id, filter) => {
            const v = row.getValue(id) as boolean;
            const s = filter.toLowerCase();
            if (s === 'active') return v === true;
            if (s === 'inactive') return v === false;
            return true;
        },
    },

    /* ----- IMAGES ----- */
    {
        id: 'images',
        header: () => <div>Images</div>,
        cell: ({ row }) => {
            // Get all images from variants
            const allImages: string[] = row.original.varants.flatMap((v) =>
                v.images.map((img) => img.image),
            );

            if (allImages.length) {
                return (
                    <div className="flex items-center gap-2">
                        <img
                            src={`/storage/${allImages[0]}`} // first image
                            alt="Product"
                            className="h-10 w-10 rounded border object-cover"
                        />
                        {allImages.length > 1 && (
                            <div className="rounded bg-gray-100 px-2 py-1 text-xs text-muted-foreground">
                                +{allImages.length - 1}
                            </div>
                        )}
                    </div>
                );
            }

            return (
                <div className="text-sm text-muted-foreground">No images</div>
            );
        },
        enableGlobalFilter: false,
    },
    /* ----- CREATED AT ----- */
    {
        accessorKey: 'created_at',
        header: () => <div>Created At</div>,
        cell: ({ row }) => {
            const d = row.getValue('created_at') as string | undefined;
            if (!d) return <div>No Date</div>;
            return (
                <div>
                    {new Date(d).toLocaleDateString('en-US', {
                        year: 'numeric',
                        month: 'short',
                        day: '2-digit',
                    })}
                </div>
            );
        },
        enableGlobalFilter: true,
        filterFn: (row, id, filter) => {
            const d = row.getValue(id) as string;
            if (!d) return false;
            const formatted = new Date(d).toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'short',
                day: '2-digit',
            });
            return formatted.toLowerCase().includes(filter.toLowerCase());
        },
    },

    /* ----- UPDATED AT ----- */
    {
        accessorKey: 'updated_at',
        header: () => <div>Updated At</div>,
        cell: ({ row }) => {
            const d = row.getValue('updated_at') as string | undefined;
            if (!d) return <div>No Date</div>;
            return (
                <div>
                    {new Date(d).toLocaleDateString('en-US', {
                        year: 'numeric',
                        month: 'short',
                        day: '2-digit',
                    })}
                </div>
            );
        },
        enableGlobalFilter: true,
        filterFn: (row, id, filter) => {
            const d = row.getValue(id) as string;
            if (!d) return false;
            const formatted = new Date(d).toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'short',
                day: '2-digit',
            });
            return formatted.toLowerCase().includes(filter.toLowerCase());
        },
    },

    /* ----- ACTIONS ----- */
    {
        id: 'actions',
        header: () => <div>Action</div>,
        cell: ({ row }) => {
            const p = row.original;
            const [open, setOpen] = React.useState(false);

            const handleDelete = () => {
                router.delete(`/product/${p.id}`);
                setOpen(false);
            };

            return (
                <>
                    <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                            <Button variant="ghost" className="h-8 w-8 p-0">
                                <span className="sr-only">Open menu</span>
                                <MoreHorizontal />
                            </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="end">
                            <DropdownMenuLabel>Actions</DropdownMenuLabel>
                            <DropdownMenuItem>
                                <a href={`product/${p.id}`}>
                                    View product details
                                </a>
                            </DropdownMenuItem>
                            <DropdownMenuItem>
                                <a href={`product/${p.id}/edit`}>
                                    Edit Product
                                </a>
                            </DropdownMenuItem>
                            <DropdownMenuSeparator />
                            <DropdownMenuItem
                                className="text-red-500"
                                onClick={() => setOpen(true)}
                            >
                                Delete
                            </DropdownMenuItem>
                        </DropdownMenuContent>
                    </DropdownMenu>

                    <AlertDialog open={open} onOpenChange={setOpen}>
                        <AlertDialogContent>
                            <AlertDialogHeader>
                                <AlertDialogTitle>
                                    Are you sure?
                                </AlertDialogTitle>
                                <AlertDialogDescription>
                                    This action cannot be undone.
                                </AlertDialogDescription>
                            </AlertDialogHeader>
                            <AlertDialogFooter>
                                <AlertDialogCancel>Cancel</AlertDialogCancel>
                                <AlertDialogAction onClick={handleDelete}>
                                    Continue
                                </AlertDialogAction>
                            </AlertDialogFooter>
                        </AlertDialogContent>
                    </AlertDialog>
                </>
            );
        },
        enableGlobalFilter: false,
    },
];

/* -------------------------------------------------------------------------- */
/*                               MAIN COMPONENT                               */
/* -------------------------------------------------------------------------- */
export default function Products({ products }: { products: Products[] }) {
    const [sorting, setSorting] = React.useState<SortingState>([]);
    const [columnFilters, setColumnFilters] =
        React.useState<ColumnFiltersState>([]);
    const [columnVisibility, setColumnVisibility] =
        React.useState<VisibilityState>({});
    const [rowSelection, setRowSelection] = React.useState({});
    const [globalFilter, setGlobalFilter] = React.useState('');

    const table = useReactTable({
        data: products,
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
            globalFilter, // <-- THIS WAS MISSING
        },
    });

    const filteredRows = table.getFilteredRowModel().rows;
    const totalFiltered = filteredRows.length;

    const newCount = filteredRows.filter((r) => r.original.new_arrival).length;
    const activeCount = filteredRows.filter((r) => r.original.is_active).length;
    const inactiveCount = filteredRows.filter(
        (r) => !r.original.is_active,
    ).length;

    return (
        <AppLayout breadcrumbs={breadcrumbs}>
            <Head title="Products" />
            <div className="flex h-full flex-1 flex-col gap-4 overflow-x-auto rounded-xl p-4">
                {/* ---------- STAT CARDS ---------- */}
                <div className="grid grid-cols-1 gap-4 *:data-[slot=card]:bg-gradient-to-t *:data-[slot=card]:from-primary/5 *:data-[slot=card]:to-card *:data-[slot=card]:shadow-xs sm:grid-cols-2 xl:grid-cols-4 @xl/main:grid-cols-2 @5xl/main:grid-cols-4 dark:*:data-[slot=card]:bg-card">
                    {/* Total */}
                    <Card className="@container/card">
                        <CardHeader>
                            <CardDescription>Total Products</CardDescription>
                            <CardTitle className="text-2xl font-semibold tabular-nums @[250px]/card:text-3xl">
                                {totalFiltered.toLocaleString()}
                            </CardTitle>
                            <CardAction>
                                <Badge variant="outline">
                                    <Boxes className="size-4" />
                                    {totalFiltered.toLocaleString()}
                                </Badge>
                            </CardAction>
                        </CardHeader>
                        <CardFooter className="flex-col items-start gap-1.5 text-sm">
                            <div className="line-clamp-1 flex gap-2 font-medium">
                                Trending up this month{' '}
                                <IconTrendingUp className="size-4" />
                            </div>
                            <div className="text-muted-foreground">
                                All products in system
                            </div>
                        </CardFooter>
                    </Card>

                    {/* New Arrival */}
                    <Card className="@container/card">
                        <CardHeader>
                            <CardDescription>New Arrival</CardDescription>
                            <CardTitle className="text-2xl font-semibold tabular-nums @[250px]/card:text-3xl">
                                {newCount.toLocaleString()}
                            </CardTitle>
                            <CardAction>
                                <Badge variant="outline">
                                    <CheckCircle className="size-4" />
                                    {newCount.toLocaleString()}
                                </Badge>
                            </CardAction>
                        </CardHeader>
                        <CardFooter className="flex-col items-start gap-1.5 text-sm">
                            <div className="line-clamp-1 flex gap-2 font-medium">
                                New products added recently{' '}
                                <CheckCircle className="size-4" />
                            </div>
                            <div className="text-muted-foreground">
                                {totalFiltered
                                    ? (
                                          (newCount / totalFiltered) *
                                          100
                                      ).toFixed(1)
                                    : 0}
                                % of total
                            </div>
                        </CardFooter>
                    </Card>

                    {/* Active */}
                    <Card className="@container/card">
                        <CardHeader>
                            <CardDescription>Active</CardDescription>
                            <CardTitle className="text-2xl font-semibold tabular-nums @[250px]/card:text-3xl">
                                {activeCount.toLocaleString()}
                            </CardTitle>
                            <CardAction>
                                <Badge variant="outline">
                                    <CheckCircle className="size-4" />
                                    {activeCount.toLocaleString()}
                                </Badge>
                            </CardAction>
                        </CardHeader>
                        <CardFooter className="flex-col items-start gap-1.5 text-sm">
                            <div className="line-clamp-1 flex gap-2 font-medium">
                                Currently available for sale{' '}
                                <CheckCircle className="size-4" />
                            </div>
                            <div className="text-muted-foreground">
                                {totalFiltered
                                    ? (
                                          (activeCount / totalFiltered) *
                                          100
                                      ).toFixed(1)
                                    : 0}
                                % of total
                            </div>
                        </CardFooter>
                    </Card>

                    {/* Inactive */}
                    <Card className="@container/card">
                        <CardHeader>
                            <CardDescription>Inactive</CardDescription>
                            <CardTitle className="text-2xl font-semibold tabular-nums @[250px]/card:text-3xl">
                                {inactiveCount.toLocaleString()}
                            </CardTitle>
                            <CardAction>
                                <Badge variant="outline">
                                    <XCircle className="size-4" />
                                    {inactiveCount.toLocaleString()}
                                </Badge>
                            </CardAction>
                        </CardHeader>
                        <CardFooter className="flex-col items-start gap-1.5 text-sm">
                            <div className="line-clamp-1 flex gap-2 font-medium">
                                Hidden or out of stock{' '}
                                <XCircle className="size-4" />
                            </div>
                            <div className="text-muted-foreground">
                                {totalFiltered
                                    ? (
                                          (inactiveCount / totalFiltered) *
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
                    <div className="flex items-center justify-between p-6 pb-4">
                        <Input
                            placeholder="Search all columns..."
                            value={globalFilter ?? ''}
                            onChange={(e) => setGlobalFilter(e.target.value)}
                            className="max-w-sm"
                        />
                        <div className="">
                            <DropdownMenu>
                                <DropdownMenuTrigger asChild>
                                    <Button variant="outline">
                                        Columns{' '}
                                        <ChevronDown className="ml-2 h-4 w-4" />
                                    </Button>
                                </DropdownMenuTrigger>
                                <DropdownMenuContent align="end">
                                    {table
                                        .getAllColumns()
                                        .filter((c) => c.getCanHide())
                                        .map((c) => (
                                            <DropdownMenuCheckboxItem
                                                key={c.id}
                                                checked={c.getIsVisible()}
                                                onCheckedChange={(v) =>
                                                    c.toggleVisibility(!!v)
                                                }
                                            >
                                                {c.id}
                                            </DropdownMenuCheckboxItem>
                                        ))}
                                </DropdownMenuContent>
                            </DropdownMenu>
                            <Tooltip>
                                <TooltipTrigger asChild>
                                    <a href="product/create">
                                        <Button
                                            variant="outline"
                                            className="ml-4"
                                        >
                                            Add New Product
                                        </Button>
                                    </a>
                                </TooltipTrigger>
                                <TooltipContent>Add new product</TooltipContent>
                            </Tooltip>
                        </div>
                    </div>

                    <div className="rounded-md border-t">
                        <Table>
                            <TableHeader>
                                {table.getHeaderGroups().map((hg) => (
                                    <TableRow key={hg.id}>
                                        {hg.headers.map((h) => (
                                            <TableHead key={h.id}>
                                                {h.isPlaceholder
                                                    ? null
                                                    : flexRender(
                                                          h.column.columnDef
                                                              .header,
                                                          h.getContext(),
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
                                            No products found.
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
