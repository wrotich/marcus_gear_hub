'use client';
import { useSearchParams } from 'next/navigation';
import ProductConfigurator from '../components/ProductConfigurator';
import Link from 'next/link';

export default function ProductPage() {
  const searchParams = useSearchParams();
  const id = searchParams.get('id');

  if (!id) {
    return (
      <div className="p-8">
        <p>Product ID is required</p>
        <Link href="/" className="text-blue-600 hover:underline">← Back to Products</Link>
      </div>
    );
  }

  return <ProductConfigurator productId={id} />;
}
