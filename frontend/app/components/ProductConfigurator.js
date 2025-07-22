'use client';
import { useState, useEffect } from 'react';
import Link from 'next/link';

const ProductConfigurator = ({ productId }) => {
  const [product, setProduct] = useState(null);
  const [selections, setSelections] = useState({});
  const [availableOptions, setAvailableOptions] = useState({});
  const [totalPrice, setTotalPrice] = useState(0);
  const [loading, setLoading] = useState(true);
  const [addingToCart, setAddingToCart] = useState(false);

  useEffect(() => {
    if (productId) {
      fetchProduct();
    }
  }, [productId]);

  useEffect(() => {
    if (product && Object.keys(selections).length > 0) {
      updateAvailableOptions();
    }
  }, [selections]);

  const fetchProduct = async () => {
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/v1/products/${productId}`);
      const data = await response.json();
      setProduct(data.product);
      setTotalPrice(data.product.base_price);
    } catch (error) {
      console.error('Error fetching product:', error);
    } finally {
      setLoading(false);
    }
  };

  const updateAvailableOptions = async () => {
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/v1/products/${productId}/available_options`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ selections })
      });
      
      const data = await response.json();
      setAvailableOptions(data.available_options);
      setTotalPrice(data.total_price);
    } catch (error) {
      console.error('Error updating options:', error);
    }
  };

  const handleSelectionChange = (partId, choiceId) => {
    setSelections(prev => ({
      ...prev,
      [partId]: choiceId
    }));
  };

  const handleAddToCart = async () => {
    setAddingToCart(true);
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/v1/cart_items`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          product_id: productId,
          selections: selections
        })
      });

      const data = await response.json();
      
      if (data.success) {
        alert('Added to cart successfully!');
        window.location.href = '/cart';
      } else {
        alert(data.error || 'Failed to add to cart');
      }
    } catch (error) {
      console.error('Error adding to cart:', error);
      alert('Failed to add to cart');
    } finally {
      setAddingToCart(false);
    }
  };

  const isConfigurationComplete = () => {
    if (!product) return false;
    
    return product.parts.filter(part => part.required).every(part => 
      selections[part.id] !== undefined
    );
  };

  if (loading) return <div className="p-8">Loading product...</div>;
  if (!product) return <div className="p-8 text-gray-900">Product not found</div>;

  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      {/* Header */}
      <div className="mb-8">
        <Link 
          href="/"
          className="text-blue-600 hover:text-blue-800 mb-4 inline-block transition-colors"
        >
          ← Back to Products
        </Link>
        <h1 className="text-3xl font-bold mb-2 text-gray-900">{product.name}</h1>
        <p className="text-gray-600">{product.description}</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Product Image */}
        <div className="aspect-square bg-gray-100 rounded-lg overflow-hidden border border-gray-200">
            <div className="flex items-center justify-center h-full text-gray-400">
              No image available
            </div>
        </div>

        {/* Configuration Panel */}
        <div className="space-y-6">
          {product.parts.map((part) => (
            <div key={part.id} className="border border-gray-200 rounded-lg p-4 bg-white">
              <h3 className="text-lg font-semibold mb-3 text-gray-900">
                {part.name}
                {part.required && <span className="text-red-500 ml-1">*</span>}
              </h3>
              
              <div className="space-y-2">
                {part.choices.map((choice) => {
                  const isAvailable = !availableOptions[part.id] || 
                    availableOptions[part.id].some(option => option.id === choice.id);
                  const isSelected = selections[part.id] === choice.id;

                  return (
                    <label
                      key={choice.id}
                      className={`
                        block p-3 border rounded-lg cursor-pointer transition-all
                        ${isSelected ? 'border-blue-500 bg-blue-50' : 'border-gray-200 hover:border-gray-300'}
                        ${!isAvailable ? 'opacity-50 cursor-not-allowed bg-gray-50' : ''}
                      `}
                    >
                      <input
                        type="radio"
                        name={`part_${part.id}`}
                        value={choice.id}
                        checked={isSelected}
                        disabled={!isAvailable}
                        onChange={() => isAvailable && handleSelectionChange(part.id, choice.id)}
                        className="sr-only"
                      />
                      
                      <div className="flex justify-between items-center">
                        <div>
                          <div className="font-medium text-gray-900">{choice.name}</div>
                          {choice.description && (
                            <div className="text-sm text-gray-600">{choice.description}</div>
                          )}
                        </div>
                        <div className="text-green-600 font-semibold">
                          +€{choice.base_price}
                        </div>
                      </div>
                      
                      {!isAvailable && (
                        <div className="text-xs text-red-600 mt-1">
                          Not available with current selection
                        </div>
                      )}
                    </label>
                  );
                })}
              </div>
            </div>
          ))}

          {/* Price Summary */}
          <div className="bg-gray-50 border border-gray-200 rounded-lg p-4">
            <div className="flex justify-between items-center mb-2">
              <span className="text-gray-700">Base Price:</span>
              <span className="text-gray-900">€{product.base_price}</span>
            </div>
            
            {Object.entries(selections).map(([partId, choiceId]) => {
              const part = product.parts.find(p => p.id.toString() === partId);
              const choice = part?.choices.find(c => c.id === choiceId);
              
              if (!choice) return null;
              
              return (
                <div key={`${partId}-${choiceId}`} className="flex justify-between items-center mb-2">
                  <span className="text-sm text-gray-600">
                    {part.name}: {choice.name}
                  </span>
                  <span className="text-sm text-gray-900">+€{choice.base_price}</span>
                </div>
              );
            })}

            <div className="border-t pt-2 mt-2">
              <div className="flex justify-between items-center">
                <span className="text-lg font-semibold text-gray-900">Total:</span>
                <span className="text-xl font-bold text-green-600">
                  €{totalPrice}
                </span>
              </div>
            </div>
          </div>

          {/* Add to Cart Button */}
          <button
            onClick={handleAddToCart}
            disabled={!isConfigurationComplete() || addingToCart}
            className={`
              w-full py-3 px-6 rounded-lg font-semibold transition-all
              ${isConfigurationComplete() && !addingToCart
                ? 'bg-blue-600 hover:bg-blue-700 text-white'
                : 'bg-gray-300 text-gray-500 cursor-not-allowed'
              }
            `}
          >
            {addingToCart ? 'Adding to Cart...' : 'Add to Cart'}
          </button>
          
          {!isConfigurationComplete() && (
            <p className="text-sm text-red-600 text-center">
              Please select all required options marked with *
            </p>
          )}
        </div>
      </div>
    </div>
  );
};

export default ProductConfigurator;
