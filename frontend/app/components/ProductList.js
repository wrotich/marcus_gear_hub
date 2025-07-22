'use client';
import { useState, useEffect } from 'react';
import Link from 'next/link';
import Image from 'next/image';

const ProductList = () => {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedCategory, setSelectedCategory] = useState('');

  useEffect(() => {
    fetchProducts();
  }, [selectedCategory]);

  const fetchProducts = async () => {
    try {
      const url = selectedCategory 
        ? `${process.env.NEXT_PUBLIC_API_URL}/api/v1/products?category=${selectedCategory}`
        : `${process.env.NEXT_PUBLIC_API_URL}/api/v1/products`;
      
      console.log('Fetching from:', url);
      
      const response = await fetch(url, {
        method: 'GET',
        credentials: 'include',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      });
      
      console.log('Response status:', response.status);
      console.log('Response headers:', response.headers);
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      const data = await response.json();
      console.log('Received data:', data);
      
      setProducts(data.products || []);
      setError(null);
    } catch (error) {
      console.error('Error fetching products:', error);
      setError(error.message);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="p-8">
        <div className="text-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p>Loading products...</p>
          <p className="text-sm text-gray-500 mt-2">
            Connecting to: {process.env.NEXT_PUBLIC_API_URL}/api/v1/products
          </p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="p-8">
        <div className="bg-red-50 border border-red-200 rounded-lg p-4">
          <h2 className="text-lg font-semibold text-red-800 mb-2">Error Loading Products</h2>
          <p className="text-red-700">{error}</p>
          <div className="mt-4 text-sm text-red-600">
            <p>Troubleshooting steps:</p>
            <ul className="list-disc list-inside mt-2 space-y-1">
              <li>Check if Rails server is running: <code>rails server -p 3001</code></li>
              <li>Test API directly: <a href="http://localhost:3001/api/v1/products" target="_blank" className="underline">http://localhost:3001/api/v1/products</a></li>
              <li>Check browser console for CORS errors (F12 → Console)</li>
              <li>Verify .env.local has: NEXT_PUBLIC_API_URL=http://localhost:3001</li>
              <li>Add rack-cors gem to Rails and restart server</li>
            </ul>
          </div>
          <button 
            onClick={fetchProducts}
            className="mt-4 bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700"
          >
            Retry
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-8 text-gray-900">Marcus Sports Shop</h1>
      
      {/* Debug Info */}
      <div className="mb-4 p-3 bg-blue-50 border border-blue-200 rounded text-sm">
        <strong>Debug Info:</strong> Found {products.length} products
        {products.length === 0 && (
          <span className="text-red-600 ml-2">
            (Try running `rails db:seed` in your Rails app)
          </span>
        )}
      </div>
      
      {/* Category Filter */}
      <div className="mb-6">
        <button
          onClick={() => setSelectedCategory('')}
          className={`mr-4 px-4 py-2 rounded transition-colors ${
            selectedCategory === '' ? 'bg-blue-600 text-white' : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
          }`}
        >
          All Products ({products.length})
        </button>
        <button
          onClick={() => setSelectedCategory('bicycle')}
          className={`mr-4 px-4 py-2 rounded transition-colors ${
            selectedCategory === 'bicycle' ? 'bg-blue-600 text-white' : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
          }`}
        >
          Bicycles ({products.filter(p => p.category === 'bicycle').length})
        </button>
        <button
          onClick={() => setSelectedCategory('ski')}
          className={`px-4 py-2 rounded transition-colors ${
            selectedCategory === 'ski' ? 'bg-blue-600 text-white' : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
          }`}
        >
          Skis ({products.filter(p => p.category === 'ski').length})
        </button>
      </div>

      {/* Products Grid */}
      {products.length > 0 ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {products.map(product => (
            <div key={product.id} className="bg-white rounded-lg shadow-md overflow-hidden border border-gray-200">
              <div className="p-4">
                <h3 className="text-lg font-semibold mb-2 text-gray-900">{product.name}</h3>
                <p className="text-gray-600 text-sm mb-4">{product.description}</p>
                <div className="flex justify-between items-center mb-4">
                  <span className="text-xl font-bold text-green-600">
                    From €{product.base_price}
                  </span>
                  <span className="text-sm text-gray-500 capitalize">
                    {product.category}
                  </span>
                </div>
                <Link 
                  href={`/product?id=${product.id}`}
                  className="w-full bg-blue-600 hover:bg-blue-700 text-white py-2 px-4 rounded block text-center transition-colors"
                >
                  Customize & Order
                </Link>
              </div>
            </div>
          ))}
        </div>
      ) : (
        <div className="text-center py-12">
          <div className="text-6xl mb-4">🚲</div>
          <h2 className="text-xl font-semibold mb-4 text-gray-900">No products found</h2>
          <p className="text-gray-600 mb-4">
            {selectedCategory 
              ? `No products in the "${selectedCategory}" category.`
              : 'No products available at the moment.'
            }
          </p>
          <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4 max-w-md mx-auto">
            <p className="text-sm text-yellow-800">
              <strong>For developers:</strong> Run <code className="bg-yellow-100 px-1 rounded">rails db:seed</code> to create sample data.
            </p>
          </div>
        </div>
      )}
    </div>
  );
};

export default ProductList;
