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
import { wishlist } from '@/routes'; // Changed from banner to wishlist
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
    Calendar,
    ChevronDown,
    Image,
    MoreHorizontal,
    Trash2,
    User,
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
import { Checkbox } from '@/components/ui/checkbox'; // Fixed import
import {
    DropdownMenu,
    DropdownMenuCheckboxItem,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { Input } from '@/components/ui/input';
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
} from '@tabler/icons-react';

import { Label } from '@/components/ui/label';
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from '@/components/ui/select';
import { format } from 'date-fns';

const breadcrumbs: BreadcrumbItem[] = [
    {
        title: 'Wishlist', // Changed from Banner to Wishlist
        href: wishlist().url, // Changed from banner to wishlist
    },
];

export type Wishlist = {
    id: number;
    users_id: number;
    products_id: number;
    created_at: string;
    updated_at: string;
    user: {
        id: number;
        first_name: string;
        last_name: string;
        email: string;
    };
    product: {
        id: number;
        name: string;
        varants: Array<{
            images: Array<{
                image: string;
            }>;
        }>;
        brand?: {
            name: string;
        };
        is_active: boolean;
    };
};

const columns: ColumnDef<Wishlist>[] = [
    /* ----- SELECT ----- */
    {
        id: 'select',
        header: ({ table }) => (
            <Checkbox
                checked={
                    table.getIsAllPageRowsSelected()
                        ? true
                        : table.getIsSomePageRowsSelected()
                        ? 'indeterminate'
                        : false
                }
                onCheckedChange={(value) => table.toggleAllPageRowsSelected(!!value)}
                aria-label="Select all"
            />
        ),
        cell: ({ row }) => (
            <Checkbox
                checked={row.getIsSelected()}
                onCheckedChange={(value) => row.toggleSelected(!!value)}
                aria-label="Select row"
            />
        ),
        enableSorting: false,
        enableHiding: false,
    },
    {
        accessorKey: 'product.varants',
        header: 'Image',
        cell: ({ row }) => {
            const variants = row.original.product.varants;
            const firstVariant = variants?.[0];
            const firstImage = firstVariant?.images?.[0]?.image;

            return (
                <div className="h-10 w-10 overflow-hidden rounded-md">
                    {firstImage ? (
                        <img
                            src={`/storage/${firstImage}`}
                            alt={row.original.product.name}
                            className="h-full w-full object-cover"
                        />
                    ) : (
                        <div className="flex h-full w-full items-center justify-center bg-muted">
                            <Image className="h-4 w-4 text-muted-foreground" />
                        </div>
                    )}
                </div>
            );
        },
    },
    {
        accessorKey: 'product.name',
        header: 'Product Name',
        cell: ({ row }) => (
            <div className="font-medium">{row.original.product.name}</div>
        ),
    },
    {
        accessorKey: 'product.brand',
        header: 'Brand',
        cell: ({ row }) => {
            const brand = row.original.product.brand;
            return (
                <div className="font-medium">{brand?.name || 'No Brand'}</div>
            );
        },
    },
    {
        accessorKey: 'product.is_active',
        header: 'Status',
        cell: ({ row }) => {
            const isActive = row.original.product.is_active;
            return (
                <Badge variant={isActive ? 'default' : 'secondary'}>
                    {isActive ? 'Active' : 'Inactive'}
                </Badge>
            );
        },
        filterFn: (row, id, value) => {
            if (!value) return true;
            const filterValue = value.toLowerCase();
            if (filterValue === 'active') return row.getValue(id) === true;
            if (filterValue === 'inactive') return row.getValue(id) === false;
            return true;
        },
    },
    {
        accessorKey: 'user',
        header: 'Added By',
        cell: ({ row }) => {
            const user = row.original.user;
            return (
                <div className="flex items-center gap-2">
                    <User className="h-4 w-4 text-muted-foreground" />
                    <span>
                        {user.first_name} {user.last_name}
                    </span>
                </div>
            );
        },
    },
    {
        accessorKey: 'created_at',
        header: 'Date Added',
        cell: ({ row }) => {
            const date = row.original.created_at;
            return (
                <div className="flex items-center gap-2 text-sm">
                    <Calendar className="h-4 w-4 text-muted-foreground" />
                    {format(new Date(date), 'MMM d, yyyy h:mm a')}
                </div>
            );
        },
    },
    {
        id: 'actions',
        header: 'Actions',
        cell: ({ row }) => {
            const wishlistItem = row.original;
            const [open, setOpen] = React.useState(false);

            const handleRemove = () => {
                router.delete(`/wishlist/${wishlistItem.id}`, {
                    onSuccess: () => setOpen(false),
                });
            };

            return (
                <>
                    <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                            <Button variant="ghost" className="h-8 w-8 p-0">
                                <MoreHorizontal className="h-4 w-4" />
                            </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="end">
                            <DropdownMenuLabel>Actions</DropdownMenuLabel>
                            <DropdownMenuItem
                                className="text-red-600"
                                onClick={() => setOpen(true)}
                            >
                                <Trash2 className="mr-2 h-4 w-4" />
                                Remove from Wishlist
                            </DropdownMenuItem>
                        </DropdownMenuContent>
                    </DropdownMenu>

                    <AlertDialog open={open} onOpenChange={setOpen}>
                        <AlertDialogContent>
                            <AlertDialogHeader>
                                <AlertDialogTitle>
                                    Remove from Wishlist?
                                </AlertDialogTitle>
                                <AlertDialogDescription>
                                    Are you sure you want to remove "
                                    <strong>{wishlistItem.product.name}</strong>
                                    " from the wishlist? This action cannot be
                                    undone.
                                </AlertDialogDescription>
                            </AlertDialogHeader>
                            <AlertDialogFooter>
                                <AlertDialogCancel>Cancel</AlertDialogCancel>
                                <AlertDialogAction
                                    onClick={handleRemove}
                                    className="bg-red-600 text-white hover:bg-red-700"
                                >
                                    Remove
                                </AlertDialogAction>
                            </AlertDialogFooter>
                        </AlertDialogContent>
                    </AlertDialog>
                </>
            );
        },
    },
];

export default function Wishlist({ wishlist }: { wishlist: Wishlist[] }) {
    const [sorting, setSorting] = React.useState<SortingState>([]);
    const [columnFilters, setColumnFilters] = React.useState<ColumnFiltersState>([]);
    const [columnVisibility, setColumnVisibility] = React.useState<VisibilityState>({});
    const [rowSelection, setRowSelection] = React.useState({});

    const table = useReactTable({
        data: wishlist,
        columns,
        onSortingChange: setSorting,
        onColumnFiltersChange: setColumnFilters,
        getCoreRowModel: getCoreRowModel(),
        getPaginationRowModel: getPaginationRowModel(),
        getSortedRowModel: getSortedRowModel(),
        getFilteredRowModel: getFilteredRowModel(),
        onColumnVisibilityChange: setColumnVisibility,
        onRowSelectionChange: setRowSelection,
        state: {
            sorting,
            columnFilters,
            columnVisibility,
            rowSelection,
        },
    });

    const filteredRows = table.getFilteredRowModel().rows;
    const totalFiltered = filteredRows.length;

    return (
        <AppLayout breadcrumbs={breadcrumbs}>
            <Head title="Wishlist" />
            <div className="flex h-full flex-1 flex-col gap-4 overflow-x-auto rounded-xl p-4">
                <div className="grid grid-cols-1 gap-4 *:data-[slot=card]:bg-gradient-to-t *:data-[slot=card]:from-primary/5 *:data-[slot=card]:to-card *:data-[slot=card]:shadow-xs sm:grid-cols-2 xl:grid-cols-3 @xl/main:grid-cols-2 @5xl/main:grid-cols-3 dark:*:data-[slot=card]:bg-card">
                    {/* Total Wishlist Items */}
                    <Card className="@container/card">
                        <CardHeader>
                            <CardDescription>Total Wishlist Items</CardDescription>
                            <CardTitle className="text-2xl font-semibold tabular-nums @[250px]/card:text-3xl">
                                {totalFiltered.toLocaleString()}
                            </CardTitle>
                            <CardAction>
                                <Badge variant="outline">
                                    <Image className="size-4" />
                                    {totalFiltered.toLocaleString()} items
                                </Badge>
                            </CardAction>
                        </CardHeader>
                        <CardFooter className="flex-col items-start gap-1.5 text-sm">
                            <div className="line-clamp-1 flex gap-2 font-medium">
                                All wishlist items in system
                            </div>
                            <div className="text-muted-foreground">
                                Products saved by users
                            </div>
                        </CardFooter>
                    </Card>
                </div>

                <div className="relative min-h-[100vh] flex-1 overflow-hidden rounded-xl border border-sidebar-border/70 px-5 md:min-h-min dark:border-sidebar-border">
                    <div className="w-full">
                        <div className="flex flex-col gap-4 py-4 sm:flex-row sm:items-center">
                            <Input
                                placeholder="Filter by product name..."
                                value={
                                    (table
                                        .getColumn('product.name')
                                        ?.getFilterValue() as string) ?? ''
                                }
                                onChange={(event) =>
                                    table
                                        .getColumn('product.name')
                                        ?.setFilterValue(event.target.value)
                                }
                                className="max-w-sm"
                            />
                            <Input
                                placeholder="Filter status (active/inactive)..."
                                value={
                                    (table
                                        .getColumn('product.is_active')
                                        ?.getFilterValue() as string) ?? ''
                                }
                                onChange={(event) =>
                                    table
                                        .getColumn('product.is_active')
                                        ?.setFilterValue(event.target.value)
                                }
                                className="max-w-sm"
                            />
                            <DropdownMenu>
                                <DropdownMenuTrigger asChild>
                                    <Button
                                        variant="outline"
                                        className="ml-auto"
                                    >
                                        Columns <ChevronDown className="ml-2 h-4 w-4" />
                                    </Button>
                                </DropdownMenuTrigger>
                                <DropdownMenuContent align="end">
                                    {table
                                        .getAllColumns()
                                        .filter((column) => column.getCanHide())
                                        .map((column) => {
                                            return (
                                                <DropdownMenuCheckboxItem
                                                    key={column.id}
                                                    className="capitalize"
                                                    checked={column.getIsVisible()}
                                                    onCheckedChange={(value) =>
                                                        column.toggleVisibility(!!value)
                                                    }
                                                >
                                                    {column.id}
                                                </DropdownMenuCheckboxItem>
                                            );
                                        })}
                                </DropdownMenuContent>
                            </DropdownMenu>
                        </div>
                        <div className="overflow-hidden rounded-md border">
                            <Table>
                                <TableHeader>
                                    {table
                                        .getHeaderGroups()
                                        .map((headerGroup) => (
                                            <TableRow key={headerGroup.id}>
                                                {headerGroup.headers.map(
                                                    (header) => {
                                                        return (
                                                            <TableHead
                                                                key={header.id}
                                                            >
                                                                {header.isPlaceholder
                                                                    ? null
                                                                    : flexRender(
                                                                          header
                                                                              .column
                                                                              .columnDef
                                                                              .header,
                                                                          header.getContext(),
                                                                      )}
                                                            </TableHead>
                                                        );
                                                    },
                                                )}
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
                                                        <TableCell
                                                            key={cell.id}
                                                        >
                                                            {flexRender(
                                                                cell.column
                                                                    .columnDef
                                                                    .cell,
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
                                                No wishlist items found.
                                            </TableCell>
                                        </TableRow>
                                    )}
                                </TableBody>
                            </Table>
                        </div>
                        <div className="flex items-center justify-between px-6 py-4">
                            <div className="hidden flex-1 text-sm text-muted-foreground lg:flex">
                                {
                                    table.getFilteredSelectedRowModel().rows
                                        .length
                                }{' '}
                                of {table.getFilteredRowModel().rows.length}{' '}
                                row(s) selected.
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
                                    Page{' '}
                                    {table.getState().pagination.pageIndex + 1}{' '}
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
            </div>
        </AppLayout>
    );
}