import { Button } from '@/components/ui/button';
import { Checkbox } from '@/components/ui/checkbox';
import { EmptyDescription } from '@/components/ui/empty';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import AppLayout from '@/layouts/app-layout';
import { type BreadcrumbItem } from '@/types';
import { Head, useForm } from '@inertiajs/react';
import {
    BadgeDollarSign,
    Check,
    ChevronsUpDown,
    ImagePlus,
    InfoIcon,
    QrCode,
    X,
} from 'lucide-react';
import * as React from 'react';

import {
    Command,
    CommandEmpty,
    CommandGroup,
    CommandInput,
    CommandItem,
    CommandList,
} from '@/components/ui/command';
import {
    Popover,
    PopoverContent,
    PopoverTrigger,
} from '@/components/ui/popover';
import { cn } from '@/lib/utils';

import { Calendar } from '@/components/ui/calendar';
import {
    InputGroup,
    InputGroupAddon,
    InputGroupInput,
    InputGroupText,
} from '@/components/ui/input-group';
import { dashboard, product } from '@/routes';
import { useEffect, useState } from 'react';
import { DateRange } from 'react-day-picker';

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: dashboard().url },
    { title: 'Products', href: product().url },
    { title: 'Product Edit', href: '#' },
];

const frameworks = [
    {
        value: 'next.js',
        label: 'Next.js',
    },
    {
        value: 'sveltekit',
        label: 'SvelteKit',
    },
    {
        value: 'nuxt.js',
        label: 'Nuxt.js',
    },
    {
        value: 'remix',
        label: 'Remix',
    },
    {
        value: 'astro',
        label: 'Astro',
    },
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

type Brand = {
    name: string;
};

type Category = {
    name: string;
};

type Size = {
    name: string;
};

type Color = {
    name: string;
};

interface Props {
    product: Product;
    brand: Brand[];
    categroy: Category[];
    size: Size[];
    color: Color[];
}

export default function ProductEdit({
    product,
    brand,
    categroy,
    size,
    color,
}: Props) {
    const { data, setData, processing, post, errors, reset } = useForm({
        name: product.name ?? '',
        description: product.description ?? '',
        is_active: product.is_active ?? true,
        new_arrival: product.new_arrival ?? false,
        brand_name: product.brand_name ?? [],
        category_name: product.category_name ?? [],
        tax: product.tax ?? '',
        sizes: product.sizes ?? [],
        colors: product.colors ?? [],
        price: product.price ?? [],
        stock: product.stock ?? [],
        image: [] as File[],
        sub_image: [] as File[][],
        code: product.code ?? '',
        discount_amount: product.discount_amount ?? '',
        start_date: product.start_date ?? '',
        end_date: product.end_date ?? '',
        _method: 'PUT' as const,
    });

    const [imagePreviews, setImagePreviews] = useState<string[][]>([[]]);
    const [subImagePreviews, setSubImagePreviews] = useState<string[][]>([[]]);
    const [openBrand, setOpenBrand] = useState<Record<number, boolean>>({});
    const [openSize, setOpenSize] = useState<Record<number, boolean>>({});
    const [openColor, setOpenColor] = useState<Record<number, boolean>>({});
    const [openCategory, setOpenCategory] = useState<Record<number, boolean>>(
        {},
    );

    const listDataBrand = brand.map((e: { name: string }) => ({
        value: e.name,
        label: e.name,
    }));

    const listDataCategory = categroy.map((e: { name: string }) => ({
        value: e.name,
        label: e.name,
    }));

    const listDataColor = color.map((e: { name: string }) => ({
        value: e.name,
        label: e.name,
    }));

    const listDataSize = size.map((e: { name: string }) => ({
        value: e.name,
        label: e.name,
    }));

    const today = new Date();
    today.setDate(today.getDate() + 2);
    const [dateRange, setDateRange] = React.useState<DateRange | undefined>({
        from: product.start_date ? new Date(product.start_date) : new Date(),
        to: product.end_date ? new Date(product.end_date) : today,
    });

    const handleOpenChangeColor = (index: number, open: boolean) => {
        setOpenColor((prev) => ({ ...prev, [index]: open }));
    };

    const handleOpenChangeSize = (index: number, open: boolean) => {
        setOpenSize((prev) => ({ ...prev, [index]: open }));
    };

    const handleOpenChangeBrand = (index: number, open: boolean) => {
        setOpenBrand((prev) => ({ ...prev, [index]: open }));
    };

    const handleOpenChangeCategory = (index: number, open: boolean) => {
        setOpenCategory((prev) => ({ ...prev, [index]: open }));
    };

    // brand and categories
    const addNewField = (field: 'brand_name' | 'category_name') => {
        setData(field, [...data[field], '']);
    };

    const updateField = (
        field: 'brand_name' | 'category_name',
        index: number,
        value: string,
    ) => {
        const updated = [...data[field]];
        updated[index] = value;
        setData(field, updated);
    };

    const removeField = (
        field: 'brand_name' | 'category_name',
        index: number,
    ) => {
        setData(
            field,
            data[field].filter((_, i) => i !== index),
        );
    };

    // variants
    const newVariant = () => {
        setData('sizes', [...data.sizes, '']);
        setData('colors', [...data.colors, '']);
        setData('price', [...data.price, 0]);
        setData('stock', [...data.stock, 0]);
        setImagePreviews([...imagePreviews, []]);
        setSubImagePreviews([...subImagePreviews, []]);
        setData('sub_image', [...data.sub_image, []]);
    };

    const updateVariant = (
        index: number,
        field: 'sizes' | 'colors' | 'price' | 'stock',
        value: string | number,
    ) => {
        const arr = [...data[field]] as any[];
        arr[index] = value;
        setData(field, arr);
    };

    const deleteVariant = (index: number) => {
        // Delete size
        const newSizes = [...data.sizes];
        newSizes.splice(index, 1);
        setData('sizes', newSizes);

        // Delete color
        const newColors = [...data.colors];
        newColors.splice(index, 1);
        setData('colors', newColors);

        // Delete price
        const newPrice = [...data.price];
        newPrice.splice(index, 1);
        setData('price', newPrice);

        // Delete stock
        const newStock = [...data.stock];
        newStock.splice(index, 1);
        setData('stock', newStock);

        // Delete main preview images
        const newImagePreviews = [...imagePreviews];
        newImagePreviews.splice(index, 1);
        setImagePreviews(newImagePreviews);

        // Delete sub preview images
        const newSubImagePreviews = [...subImagePreviews];
        newSubImagePreviews.splice(index, 1);
        setSubImagePreviews(newSubImagePreviews);

        // Delete sub_image array
        const newSubImages = [...data.sub_image];
        newSubImages.splice(index, 1);
        setData('sub_image', newSubImages);

        // Delete image file
        const newImages = [...data.image];
        newImages.splice(index, 1);
        setData('image', newImages);
    };

    const coupons = (
        field: 'discount_amount' | 'start_date' | 'end_date' | 'code',
        value: string,
    ) => {
        setData(field, value);
    };

 
    // Initialize image previews on mount
    useEffect(() => {
        const base = '/storage/';
        const normalize = (p: string) =>
            p &&
            !p.startsWith('http') &&
            !p.startsWith('blob') &&
            !p.startsWith('/')
                ? base + p
                : p;

        // Handle main images
        const mainImages = Array.isArray(product.image)
            ? product.image.map((img) => [normalize(img)])
            : [[normalize(product.image)]];

        // Handle sub images
        const subImages = Array.isArray(product.sub_image)
            ? product.sub_image.map((imgs: string | string[]) =>
                  Array.isArray(imgs) ? imgs.map(normalize) : [normalize(imgs)],
              )
            : [[]];

        const variantCount = getVariantCount();
        setImagePreviews(
            mainImages.length ? mainImages : Array(variantCount).fill([]),
        );
        setSubImagePreviews(
            subImages.length ? subImages : Array(variantCount).fill([]),
        );
    }, [product]);

    const handleChangeImage = (
        e: React.ChangeEvent<HTMLInputElement>,
        variantIndex: number,
    ) => {
        const file = e.target.files?.[0];
        if (!file) return;

        const updatedFiles = [...data.image];
        updatedFiles[variantIndex] = file;
        setData('image', updatedFiles);

        const preview = URL.createObjectURL(file);
        const updatedPreviews = [...imagePreviews];
        updatedPreviews[variantIndex] = [preview];
        setImagePreviews(updatedPreviews);
    };

    const handleChangeSubImage = (
        e: React.ChangeEvent<HTMLInputElement>,
        variantIndex: number,
    ) => {
        const files = Array.from(e.target.files ?? []);
        if (files.length === 0) return;

        const currentSub = data.sub_image[variantIndex] || [];
        const updatedSub = [...data.sub_image];
        updatedSub[variantIndex] = [...currentSub, ...files];
        setData('sub_image', updatedSub);

        const newPreviews = files.map((f) => URL.createObjectURL(f));
        const updatedPreviews = [...subImagePreviews];
        updatedPreviews[variantIndex] = [
            ...(updatedPreviews[variantIndex] || []),
            ...newPreviews,
        ];
        setSubImagePreviews(updatedPreviews);
    };

    const removeSubImage = (variantIndex: number, subImageIndex: number) => {
        const updatedFiles = [...data.sub_image];
        updatedFiles[variantIndex] = updatedFiles[variantIndex].filter(
            (_, i) => i !== subImageIndex,
        );
        setData('sub_image', updatedFiles);

        const updatedPreviews = [...subImagePreviews];
        updatedPreviews[variantIndex] = updatedPreviews[variantIndex].filter(
            (_, i) => i !== subImageIndex,
        );
        setSubImagePreviews(updatedPreviews);
    };

    const getVariantCount = () => {
        return Math.max(
            data.sizes.length,
            data.colors.length,
            data.price.length,
            data.stock.length,
        );
    };

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        post(`/product/${product.id}`);
    };

    const variantCount = getVariantCount();

    return (
        <AppLayout breadcrumbs={breadcrumbs}>
            <Head title="Edit Product" />
            <div className="flex h-full flex-1 flex-col gap-4 overflow-x-auto rounded-xl p-4">
                <div className="relative min-h-[100vh] flex-1 overflow-hidden rounded-xl border border-sidebar-border/70 md:min-h-min dark:border-sidebar-border">
                    <form
                        onSubmit={handleSubmit}
                        className="flex h-full flex-col p-5"
                    >
                        <Label htmlFor="name" className="pb-5">
                            Name and Description
                        </Label>
                        <div className="my-5 rounded-xl border p-5">
                            {/* name product */}
                            <div className="flex flex-col">
                                <Input
                                    id="name"
                                    name="name"
                                    value={data?.name ?? ''}
                                    type="text"
                                    placeholder="Product Title"
                                    className="h-13"
                                    onChange={(e) =>
                                        setData('name', e.target.value)
                                    }
                                />
                            </div>

                            {/* description */}
                            <div className="my-5 mt-10">
                                <Label htmlFor="description">Description</Label>
                                <Textarea
                                    id="description"
                                    name="description"
                                    value={data?.description ?? ''}
                                    placeholder="Type your description here."
                                    className="my-5 h-50"
                                    onChange={(e) =>
                                        setData('description', e.target.value)
                                    }
                                />
                            </div>
                        </div>

                        {/* brand and category */}
                        <div className="mt-10">
                            <Label htmlFor="name" className="pb-5">
                                Brand and Categories
                            </Label>
                            <div className="my-5 rounded-xl border p-5">
                                <div className="grid grid-cols-1 gap-4 lg:grid-cols-2">
                                    {/* category */}
                                    <div className="">
                                        {data.category_name.map((value, i) => (
                                            <div
                                                key={i}
                                                className="flex w-full items-center py-3"
                                            >
                                                <Popover
                                                    open={openCategory[i]}
                                                    onOpenChange={(open) =>
                                                        handleOpenChangeCategory(
                                                            i,
                                                            open,
                                                        )
                                                    }
                                                >
                                                    <PopoverTrigger asChild>
                                                        <Button
                                                            variant="outline"
                                                            role="combobox"
                                                            aria-expanded={
                                                                openCategory[i]
                                                            }
                                                            className="h-13 w-full justify-between"
                                                        >
                                                            {value
                                                                ? listDataCategory.find(
                                                                      (
                                                                          framework,
                                                                      ) =>
                                                                          framework.value ===
                                                                          value,
                                                                  )?.label
                                                                : 'Select Category...'}
                                                            <ChevronsUpDown className="opacity-50" />
                                                        </Button>
                                                    </PopoverTrigger>
                                                    <PopoverContent className="w-[var(--radix-popover-trigger-width)] p-0">
                                                        <Command>
                                                            <CommandInput
                                                                placeholder="Search Category..."
                                                                className="h-9"
                                                            />
                                                            <CommandList>
                                                                <CommandEmpty>
                                                                    No framework
                                                                    found.
                                                                </CommandEmpty>
                                                                <CommandGroup>
                                                                    {listDataCategory.map(
                                                                        (
                                                                            framework,
                                                                        ) => (
                                                                            <CommandItem
                                                                                key={
                                                                                    framework.value
                                                                                }
                                                                                value={
                                                                                    framework.value
                                                                                }
                                                                                onSelect={() => {
                                                                                    updateField(
                                                                                        'category_name',
                                                                                        i,
                                                                                        framework.value,
                                                                                    );
                                                                                    handleOpenChangeCategory(
                                                                                        i,
                                                                                        false,
                                                                                    );
                                                                                }}
                                                                            >
                                                                                {
                                                                                    framework.label
                                                                                }
                                                                                <Check
                                                                                    className={cn(
                                                                                        'ml-auto',
                                                                                        value ===
                                                                                            framework.value
                                                                                            ? 'opacity-100'
                                                                                            : 'opacity-0',
                                                                                    )}
                                                                                />
                                                                            </CommandItem>
                                                                        ),
                                                                    )}
                                                                </CommandGroup>
                                                            </CommandList>
                                                        </Command>
                                                    </PopoverContent>
                                                </Popover>
                                                {data.category_name.length >
                                                    1 && (
                                                    <Button
                                                        size="icon"
                                                        className="mx-3 h-13 w-13"
                                                        variant="ghost"
                                                        type="button"
                                                        onClick={() =>
                                                            removeField(
                                                                'category_name',
                                                                i,
                                                            )
                                                        }
                                                    >
                                                        <X className="h-5 w-5" />
                                                    </Button>
                                                )}
                                            </div>
                                        ))}
                                        <Button
                                            variant="outline"
                                            size="sm"
                                            type="button"
                                            className=""
                                            onClick={() =>
                                                addNewField('category_name')
                                            }
                                        >
                                            +
                                        </Button>
                                    </div>

                                    {/* brand */}
                                    <div className="w-full">
                                        {data.brand_name.map((value, i) => (
                                            <div
                                                key={i}
                                                className="flex items-center"
                                            >
                                                <Popover
                                                    open={openBrand[i]}
                                                    onOpenChange={(open) =>
                                                        handleOpenChangeBrand(
                                                            i,
                                                            open,
                                                        )
                                                    }
                                                >
                                                    <PopoverTrigger asChild>
                                                        <Button
                                                            variant="outline"
                                                            role="combobox"
                                                            aria-expanded={
                                                                openBrand[i]
                                                            }
                                                            className="my-3 h-13 w-full justify-between"
                                                        >
                                                            {value
                                                                ? listDataBrand.find(
                                                                      (
                                                                          framework,
                                                                      ) =>
                                                                          framework.value ===
                                                                          value,
                                                                  )?.label
                                                                : 'Select Brand...'}
                                                            <ChevronsUpDown className="opacity-50" />
                                                        </Button>
                                                    </PopoverTrigger>
                                                    <PopoverContent className="w-[var(--radix-popover-trigger-width)] p-0">
                                                        <Command>
                                                            <CommandInput
                                                                placeholder="Search Brand..."
                                                                className="h-9"
                                                            />
                                                            <CommandList>
                                                                <CommandEmpty>
                                                                    No brand
                                                                    found.
                                                                </CommandEmpty>
                                                                <CommandGroup>
                                                                    {listDataBrand.map(
                                                                        (
                                                                            framework,
                                                                        ) => (
                                                                            <CommandItem
                                                                                key={
                                                                                    framework.value
                                                                                }
                                                                                value={
                                                                                    framework.value
                                                                                }
                                                                                onSelect={() => {
                                                                                    updateField(
                                                                                        'brand_name',
                                                                                        i,
                                                                                        framework.value,
                                                                                    );
                                                                                    handleOpenChangeBrand(
                                                                                        i,
                                                                                        false,
                                                                                    );
                                                                                }}
                                                                            >
                                                                                {
                                                                                    framework.label
                                                                                }
                                                                                <Check
                                                                                    className={cn(
                                                                                        'ml-auto',
                                                                                        value ===
                                                                                            framework.value
                                                                                            ? 'opacity-100'
                                                                                            : 'opacity-0',
                                                                                    )}
                                                                                />
                                                                            </CommandItem>
                                                                        ),
                                                                    )}
                                                                </CommandGroup>
                                                            </CommandList>
                                                        </Command>
                                                    </PopoverContent>
                                                </Popover>
                                                {data.brand_name.length > 1 && (
                                                    <Button
                                                        size="icon"
                                                        className="mx-3 h-13 w-13"
                                                        variant="ghost"
                                                        type="button"
                                                        onClick={() =>
                                                            removeField(
                                                                'brand_name',
                                                                i,
                                                            )
                                                        }
                                                    >
                                                        <X className="h-5 w-5" />
                                                    </Button>
                                                )}
                                            </div>
                                        ))}
                                        <Button
                                            variant="outline"
                                            size="sm"
                                            type="button"
                                            className="mt-2"
                                            onClick={() =>
                                                addNewField('brand_name')
                                            }
                                        >
                                            +
                                        </Button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        {/* variants */}
                        <div className="">
                            <Label htmlFor="name" className="mt-10 py-5">
                                Variants
                            </Label>
                            <div className="">
                                {Array.from({ length: variantCount }).map(
                                    (_, i) => {
                                        return (
                                            <div
                                                className="relative my-5 rounded-xl border p-5"
                                                key={i}
                                            >
                                                {variantCount > 1 && (
                                                    <Button
                                                        size="icon"
                                                        className="absolute top-2 right-2 z-10 h-8 w-8"
                                                        variant="ghost"
                                                        type="button"
                                                        onClick={() =>
                                                            deleteVariant(i)
                                                        }
                                                    >
                                                        <X className="h-4 w-4" />
                                                    </Button>
                                                )}
                                                <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
                                                    {/* color */}
                                                    <div className="">
                                                        <Label htmlFor="name">
                                                            Color
                                                        </Label>
                                                        <div className="py-2">
                                                            <Popover
                                                                open={
                                                                    openColor[i]
                                                                }
                                                                onOpenChange={(
                                                                    e,
                                                                ) =>
                                                                    handleOpenChangeColor(
                                                                        i,
                                                                        e,
                                                                    )
                                                                }
                                                            >
                                                                <PopoverTrigger
                                                                    asChild
                                                                >
                                                                    <Button
                                                                        variant="outline"
                                                                        role="combobox"
                                                                        aria-expanded={
                                                                            openColor[
                                                                                i
                                                                            ]
                                                                        }
                                                                        className="h-13 w-full justify-between"
                                                                    >
                                                                        {data
                                                                            .colors[
                                                                            i
                                                                        ]
                                                                            ? listDataColor.find(
                                                                                  (
                                                                                      framework,
                                                                                  ) =>
                                                                                      framework.value ===
                                                                                      data
                                                                                          .colors[
                                                                                          i
                                                                                      ],
                                                                              )
                                                                                  ?.label
                                                                            : 'Select color...'}
                                                                        <ChevronsUpDown className="opacity-50" />
                                                                    </Button>
                                                                </PopoverTrigger>
                                                                <PopoverContent className="w-[var(--radix-popover-trigger-width)] p-0">
                                                                    <Command>
                                                                        <CommandInput
                                                                            placeholder="Search color..."
                                                                            className="h-9"
                                                                        />
                                                                        <CommandList>
                                                                            <CommandEmpty>
                                                                                No
                                                                                framework
                                                                                found.
                                                                            </CommandEmpty>
                                                                            <CommandGroup>
                                                                                {listDataColor.map(
                                                                                    (
                                                                                        framework,
                                                                                    ) => (
                                                                                        <CommandItem
                                                                                            key={
                                                                                                framework.value
                                                                                            }
                                                                                            value={
                                                                                                framework.value
                                                                                            }
                                                                                            onSelect={(
                                                                                                currentValue,
                                                                                            ) => {
                                                                                                updateVariant(
                                                                                                    i,
                                                                                                    'colors',
                                                                                                    currentValue,
                                                                                                );
                                                                                                handleOpenChangeColor(
                                                                                                    i,
                                                                                                    false,
                                                                                                );
                                                                                            }}
                                                                                        >
                                                                                            {
                                                                                                framework.label
                                                                                            }
                                                                                            <Check
                                                                                                className={cn(
                                                                                                    'ml-auto',
                                                                                                    data
                                                                                                        .colors[
                                                                                                        i
                                                                                                    ] ===
                                                                                                        framework.value
                                                                                                        ? 'opacity-100'
                                                                                                        : 'opacity-0',
                                                                                                )}
                                                                                            />
                                                                                        </CommandItem>
                                                                                    ),
                                                                                )}
                                                                            </CommandGroup>
                                                                        </CommandList>
                                                                    </Command>
                                                                </PopoverContent>
                                                            </Popover>
                                                        </div>
                                                    </div>

                                                    {/* size */}
                                                    <div className="">
                                                        <Label htmlFor="name">
                                                            Size
                                                        </Label>
                                                        <div className="py-2">
                                                            <Popover
                                                                open={
                                                                    openSize[i]
                                                                }
                                                                onOpenChange={(
                                                                    e,
                                                                ) =>
                                                                    handleOpenChangeSize(
                                                                        i,
                                                                        e,
                                                                    )
                                                                }
                                                            >
                                                                <PopoverTrigger
                                                                    asChild
                                                                >
                                                                    <Button
                                                                        variant="outline"
                                                                        role="combobox"
                                                                        aria-expanded={
                                                                            openSize[
                                                                                i
                                                                            ]
                                                                        }
                                                                        className="h-13 w-full justify-between"
                                                                    >
                                                                        {data
                                                                            .sizes[
                                                                            i
                                                                        ]
                                                                            ? listDataSize.find(
                                                                                  (
                                                                                      framework,
                                                                                  ) =>
                                                                                      framework.value ===
                                                                                      data
                                                                                          .sizes[
                                                                                          i
                                                                                      ],
                                                                              )
                                                                                  ?.label
                                                                            : 'Select size...'}
                                                                        <ChevronsUpDown className="opacity-50" />
                                                                    </Button>
                                                                </PopoverTrigger>
                                                                <PopoverContent className="w-[var(--radix-popover-trigger-width)] p-0">
                                                                    <Command>
                                                                        <CommandInput
                                                                            placeholder="Search size..."
                                                                            className="h-9"
                                                                        />
                                                                        <CommandList>
                                                                            <CommandEmpty>
                                                                                No
                                                                                size
                                                                                found.
                                                                            </CommandEmpty>
                                                                            <CommandGroup>
                                                                                {listDataSize.map(
                                                                                    (
                                                                                        framework,
                                                                                    ) => (
                                                                                        <CommandItem
                                                                                            key={
                                                                                                framework.value
                                                                                            }
                                                                                            value={
                                                                                                framework.value
                                                                                            }
                                                                                            onSelect={(
                                                                                                currentValue,
                                                                                            ) => {
                                                                                                updateVariant(
                                                                                                    i,
                                                                                                    'sizes',
                                                                                                    currentValue,
                                                                                                );
                                                                                                handleOpenChangeSize(
                                                                                                    i,
                                                                                                    false,
                                                                                                );
                                                                                            }}
                                                                                        >
                                                                                            {
                                                                                                framework.label
                                                                                            }
                                                                                            <Check
                                                                                                className={cn(
                                                                                                    'ml-auto',
                                                                                                    data
                                                                                                        .sizes[
                                                                                                        i
                                                                                                    ] ===
                                                                                                        framework.value
                                                                                                        ? 'opacity-100'
                                                                                                        : 'opacity-0',
                                                                                                )}
                                                                                            />
                                                                                        </CommandItem>
                                                                                    ),
                                                                                )}
                                                                            </CommandGroup>
                                                                        </CommandList>
                                                                    </Command>
                                                                </PopoverContent>
                                                            </Popover>
                                                        </div>
                                                    </div>

                                                    {/* price */}
                                                    <div className="">
                                                        <Label htmlFor="price">
                                                            Price
                                                        </Label>
                                                        <div className="py-3">
                                                            <InputGroup className="h-13">
                                                                <InputGroupAddon>
                                                                    <InputGroupText>
                                                                        $
                                                                    </InputGroupText>
                                                                </InputGroupAddon>
                                                                <InputGroupInput
                                                                    className=""
                                                                    name="price"
                                                                    type="number"
                                                                    value={
                                                                        data
                                                                            .price[
                                                                            i
                                                                        ] || ''
                                                                    }
                                                                    onChange={(
                                                                        e,
                                                                    ) =>
                                                                        updateVariant(
                                                                            i,
                                                                            'price',
                                                                            e
                                                                                .target
                                                                                .value,
                                                                        )
                                                                    }
                                                                    placeholder="0.00"
                                                                />
                                                                <InputGroupAddon align="inline-end">
                                                                    <InputGroupText>
                                                                        USD
                                                                    </InputGroupText>
                                                                </InputGroupAddon>
                                                            </InputGroup>
                                                        </div>
                                                    </div>

                                                    {/* stock */}
                                                    <div className="">
                                                        <Label htmlFor="stock">
                                                            Stock
                                                        </Label>
                                                        <div className="py-3">
                                                            <InputGroup className="h-13">
                                                                <InputGroupInput
                                                                    className=""
                                                                    name="stock"
                                                                    type="number"
                                                                    value={
                                                                        data
                                                                            .stock[
                                                                            i
                                                                        ] || ''
                                                                    }
                                                                    onChange={(
                                                                        e,
                                                                    ) =>
                                                                        updateVariant(
                                                                            i,
                                                                            'stock',
                                                                            e
                                                                                .target
                                                                                .value,
                                                                        )
                                                                    }
                                                                    placeholder="00"
                                                                />
                                                                <InputGroupAddon align="inline-end">
                                                                    <InputGroupText>
                                                                        <InfoIcon />
                                                                    </InputGroupText>
                                                                </InputGroupAddon>
                                                            </InputGroup>
                                                        </div>
                                                    </div>
                                                </div>

                                                {/* image and sub image */}
                                                <div className="grid grid-cols-1 gap-4 lg:grid-cols-2">
                                                    {/* image */}
                                                    <div className="flex h-full flex-1 flex-col">
                                                        <Label
                                                            htmlFor="image"
                                                            className="py-5"
                                                        >
                                                            Images
                                                        </Label>
                                                        <Label
                                                            htmlFor={`image${i}`}
                                                            className="flex h-full min-h-[400px] items-center justify-center rounded-md border border-input bg-transparent px-3 py-1 text-base shadow-xs transition-[color,box-shadow] outline-none selection:bg-primary selection:text-primary-foreground file:inline-flex file:h-7 file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground placeholder:text-muted-foreground focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50 aria-invalid:border-destructive aria-invalid:ring-destructive/20 md:text-sm dark:aria-invalid:ring-destructive/40"
                                                        >
                                                            <div>
                                                                {imagePreviews[
                                                                    i
                                                                ]?.[0] ? (
                                                                    <img
                                                                        src={String(
                                                                            imagePreviews[
                                                                                i
                                                                            ][0],
                                                                        )}
                                                                        className="rounded-sm object-cover"
                                                                        alt=""
                                                                    />
                                                                ) : (
                                                                    <div className="flex flex-col items-center justify-center text-gray-700">
                                                                        <ImagePlus className="h-10 w-10" />
                                                                        <EmptyDescription className="text-center">
                                                                            You
                                                                            can't
                                                                            created
                                                                            any
                                                                            sub
                                                                            image.
                                                                            <br />{' '}
                                                                            Get
                                                                            started
                                                                            by
                                                                            creating
                                                                            your
                                                                            first
                                                                            image.
                                                                        </EmptyDescription>
                                                                    </div>
                                                                )}
                                                            </div>
                                                            <Input
                                                                id={`image${i}`}
                                                                type="file"
                                                                name="image[]"
                                                                accept="image/*"
                                                                className="hidden"
                                                                onChange={(e) =>
                                                                    handleChangeImage(
                                                                        e,
                                                                        i,
                                                                    )
                                                                }
                                                            />
                                                        </Label>
                                                    </div>

                                                    {/* sub image */}
                                                    <div className="flex h-full flex-1 flex-col">
                                                        <Label
                                                            htmlFor="sub_image"
                                                            className="py-5"
                                                        >
                                                            Sub Images
                                                        </Label>
                                                        <Label
                                                            htmlFor={`sub_image${i}`}
                                                            className="flex h-full min-w-0 justify-center rounded-md border border-input bg-transparent px-3 py-1 text-base shadow-xs transition-[color,box-shadow] outline-none selection:bg-primary selection:text-primary-foreground file:inline-flex file:h-7 file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground placeholder:text-muted-foreground focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50 aria-invalid:border-destructive aria-invalid:ring-destructive/20 md:text-sm dark:aria-invalid:ring-destructive/40"
                                                        >
                                                            <div className="h-full">
                                                                {subImagePreviews[
                                                                    i
                                                                ] &&
                                                                subImagePreviews[
                                                                    i
                                                                ].length > 0 ? (
                                                                    <div className="flex items-start">
                                                                        <div className="grid w-full gap-5 lg:grid-cols-2 xl:grid-cols-3">
                                                                            {subImagePreviews[
                                                                                i
                                                                            ].map(
                                                                                (
                                                                                    e,
                                                                                    index,
                                                                                ) => (
                                                                                    <div
                                                                                        key={
                                                                                            index
                                                                                        }
                                                                                        className="relative"
                                                                                    >
                                                                                        <img
                                                                                            src={String(
                                                                                                e,
                                                                                            )}
                                                                                            className="h-full object-cover"
                                                                                            alt=""
                                                                                        />
                                                                                        <Button
                                                                                            type="button"
                                                                                            size="icon"
                                                                                            variant="ghost"
                                                                                            className="absolute top-0 right-0"
                                                                                            onClick={(
                                                                                                e,
                                                                                            ) => {
                                                                                                e.preventDefault();
                                                                                                removeSubImage(
                                                                                                    i,
                                                                                                    index,
                                                                                                );
                                                                                            }}
                                                                                        >
                                                                                            <X />
                                                                                        </Button>
                                                                                    </div>
                                                                                ),
                                                                            )}
                                                                        </div>
                                                                    </div>
                                                                ) : (
                                                                    <div className="flex h-full">
                                                                        <div className="flex flex-col items-center justify-center text-gray-700">
                                                                            <ImagePlus className="h-10 w-10" />
                                                                            <EmptyDescription className="text-center">
                                                                                Multiple
                                                                                sub-images
                                                                                per
                                                                                variant
                                                                                <br />
                                                                                Get
                                                                                started
                                                                                by
                                                                                creating
                                                                                your
                                                                                first
                                                                                image.
                                                                            </EmptyDescription>
                                                                        </div>
                                                                    </div>
                                                                )}
                                                            </div>
                                                            <Input
                                                                id={`sub_image${i}`}
                                                                type="file"
                                                                name="sub_image[]"
                                                                accept="image/*"
                                                                className="hidden"
                                                                multiple
                                                                onChange={(e) =>
                                                                    handleChangeSubImage(
                                                                        e,
                                                                        i,
                                                                    )
                                                                }
                                                            />
                                                        </Label>
                                                    </div>
                                                </div>
                                            </div>
                                        );
                                    },
                                )}
                                <Button
                                    type="button"
                                    size="sm"
                                    variant="outline"
                                    className="mt-2"
                                    onClick={newVariant}
                                >
                                    +
                                </Button>
                            </div>
                        </div>

                        {/* coupons */}
                        <div className="">
                            <Label htmlFor="name" className="mt-10 py-5">
                                Coupons
                            </Label>
                            <div className="my-5 rounded-xl border p-5">
                                <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
                                    {/* code */}
                                    <div className="">
                                        <Label htmlFor="code">Code</Label>
                                        <div className="py-3">
                                            <InputGroup className="h-13">
                                                <InputGroupAddon>
                                                    <InputGroupText>
                                                        <QrCode />
                                                    </InputGroupText>
                                                </InputGroupAddon>
                                                <InputGroupInput
                                                    className=""
                                                    type="text"
                                                    value={data.code}
                                                    onChange={(e) => {
                                                        coupons(
                                                            'code',
                                                            e.target.value,
                                                        );
                                                    }}
                                                    placeholder="0.00"
                                                />
                                            </InputGroup>
                                        </div>
                                    </div>

                                    {/* discount */}
                                    <div className="">
                                        <Label htmlFor="name">Discount</Label>
                                        <div className="py-3">
                                            <InputGroup className="h-13">
                                                <InputGroupInput
                                                    className=""
                                                    type="number"
                                                    value={data.discount_amount}
                                                    onChange={(e) =>
                                                        coupons(
                                                            'discount_amount',
                                                            e.target.value,
                                                        )
                                                    }
                                                    placeholder="0.00"
                                                />
                                                <InputGroupAddon align="inline-end">
                                                    <InputGroupText>
                                                        <BadgeDollarSign />
                                                    </InputGroupText>
                                                </InputGroupAddon>
                                            </InputGroup>
                                        </div>
                                    </div>
                                </div>

                                <div className="py-5">
                                    <Label htmlFor="code">Date</Label>
                                </div>
                                <div className="">
                                    <Calendar
                                        mode="range"
                                        defaultMonth={dateRange?.from}
                                        selected={dateRange}
                                        onSelect={(r) => {
                                            if (r?.from) {
                                                coupons(
                                                    'start_date',
                                                    r.from.toISOString(),
                                                );
                                            }
                                            if (r?.to) {
                                                coupons(
                                                    'end_date',
                                                    r.to.toISOString(),
                                                );
                                                setDateRange(r);
                                            }
                                        }}
                                        numberOfMonths={2}
                                        className="rounded-lg border shadow-sm"
                                    />
                                </div>
                            </div>
                        </div>

                        {/* Tax */}
                        <div className="">
                            <Label htmlFor="name" className="mt-10 py-5">
                                Tax
                            </Label>
                            <div className="my-5 rounded-xl border p-5">
                                <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
                                    {/* tax */}
                                    <div className="">
                                        <Label htmlFor="name">Tax</Label>
                                        <div className="py-3">
                                            <InputGroup className="h-13">
                                                <InputGroupInput
                                                    className=""
                                                    name="tax"
                                                    type="number"
                                                    value={data?.tax ?? ''}
                                                    onChange={(e) =>
                                                        setData(
                                                            'tax',
                                                            Number(
                                                                e.target.value,
                                                            ),
                                                        )
                                                    }
                                                    placeholder="0.00"
                                                />
                                                <InputGroupAddon align="inline-end">
                                                    <InputGroupText>
                                                        <BadgeDollarSign />
                                                    </InputGroupText>
                                                </InputGroupAddon>
                                            </InputGroup>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        {/* active */}
                        <div className="flex flex-col items-end">
                            <div className="flex items-center gap-3">
                                <Checkbox
                                    id="new_arrival"
                                    checked={data.new_arrival}
                                    onCheckedChange={(e) =>
                                        setData('new_arrival', Boolean(e))
                                    }
                                />
                                <Label htmlFor="new_arrival">
                                    Get started your first product
                                </Label>
                            </div>
                            <Label className="my-5 flex w-[350px] items-start gap-3 rounded-lg border p-3 hover:bg-accent/50 has-[[aria-checked=true]]:border-blue-600 has-[[aria-checked=true]]:bg-blue-50 dark:has-[[aria-checked=true]]:border-blue-900 dark:has-[[aria-checked=true]]:bg-blue-950">
                                <Checkbox
                                    id="is_active"
                                    checked={data.is_active}
                                    defaultChecked
                                    className="data-[state=checked]:border-blue-600 data-[state=checked]:bg-blue-600 data-[state=checked]:text-white dark:data-[state=checked]:border-blue-700 dark:data-[state=checked]:bg-blue-700"
                                    onCheckedChange={(e) =>
                                        setData('is_active', Boolean(e))
                                    }
                                />
                                <div className="grid gap-1.5 font-normal">
                                    <p className="text-sm leading-none font-medium">
                                        Enable product
                                    </p>
                                    <p className="text-sm text-muted-foreground">
                                        You can enable or disable product at any
                                        time.
                                    </p>
                                </div>
                            </Label>
                        </div>

                        <div className="flex items-center justify-end gap-4">
                            <Button
                                disabled={processing}
                                data-test="update-profile-button"
                                className="w-[350px]"
                            >
                                Update
                            </Button>
                        </div>
                    </form>
                </div>
            </div>
        </AppLayout>
    );
}
