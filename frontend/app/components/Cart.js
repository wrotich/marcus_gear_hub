'use client';
import { useState, useEffect } from 'react';
import Link from 'next/link';

const Cart = () => {
  const [cartData, setCartData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [updating, setUpdating] = useState({});

  useEffect(() => {
    fetchCart();
  }, []);

  const fetchCart = async () => {
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/v1/cart_items`, { credentials: 'include' });
      const data = await response.json();
      console.log('API Response:', data);
      console.log('Cart data:', data.cart);
      console.log('Items count:', data.cart?.items?.length);
      setCartData(data.cart);
    } catch (error) {
      console.error('Error fetching cart:', error);
    } finally {
      setLoading(false);
    }
  };

  const updateQuantity = async (itemId, newQuantity) => {
    if (newQuantity < 1) return;
    
    setUpdating(prev => ({ ...prev, [itemId]: true }));
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/v1/cart_items/${itemId}`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ quantity: newQuantity })
      });

      const data = await response.json();
      
      if (data.success) {
        setCartData(prevCart => ({
          ...prevCart,
          items: prevCart.items.map(item =>
            item.id === itemId 
              ? { ...item, quantity: newQuantity, total_price: data.cart_item.total_price }
              : item
          ),
          total_price: data.cart_total,
          item_count: data.cart_count
        }));
      }
    } catch (error) {
      console.error('Error updating quantity:', error);
    } finally {
      setUpdating(prev => ({ ...prev, [itemId]: false }));
    }
  };

  const removeItem = async (itemId) => {
    setUpdating(prev => ({ ...prev, [itemId]: true }));
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/v1/cart_items/${itemId}`, {
        method: 'DELETE'
      });

      const data = await response.json();
      
      if (data.success) {
        setCartData(prevCart => ({
          ...prevCart,
          items: prevCart.items.filter(item => item.id !== itemId),
          total_price: data.cart_total,
          item_count: data.cart_count
        }));
      }
    } catch (error) {
      console.error('Error removing item:', error);
    } finally {
      setUpdating(prev => ({ ...prev, [itemId]: false }));
    }
  };

  if (loading) return <div className="p-8">Loading cart...</div>;

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-8">Shopping Cart</h1>

      {cartData && cartData.items && cartData.items.length > 0 ? (
        <div className="space-y-6">
          {cartData.items.map(item => (
            <div key={item.id} className="bg-white border rounded-lg p-6 shadow-sm">
              <div className="flex justify-between items-start mb-4">
                <h3 className="text-lg font-semibold text-gray-900">{item.product_name}</h3>
                <button
                  onClick={() => removeItem(item.id)}
                  disabled={updating[item.id]}
                  className="text-red-600 hover:text-red-800 disabled:opacity-50"
                >
                  Remove
                </button>
              </div>
              
              {/* Configuration Summary */}
              <div className="mb-4">
                <h4 className="text-sm font-medium text-gray-600 mb-2">Configuration:</h4>
                <div className="grid grid-cols-2 md:grid-cols-3 gap-2 text-sm text-gray-700">
                  {Object.entries(item.configuration || {}).map(([part, choice]) => (
                    <div key={part}>
                      <span className="font-medium">{part}:</span> {choice}
                    </div>
                  ))}
                </div>
              </div>

              {/* Quantity and Price */}
              <div className="flex justify-between items-center">
                <div className="flex items-center space-x-3">
                  <span className="text-sm text-gray-600">Quantity:</span>
                  <div className="flex items-center space-x-2">
                    <button
                      onClick={() => updateQuantity(item.id, item.quantity - 1)}
                      disabled={item.quantity <= 1 || updating[item.id]}
                      className="w-8 h-8 rounded border border-gray-300 hover:bg-gray-50 disabled:opacity-50 flex items-center justify-center"
                    >
                      -
                    </button>
                    <span className="w-8 text-center">{item.quantity}</span>
                    <button
                      onClick={() => updateQuantity(item.id, item.quantity + 1)}
                      disabled={updating[item.id]}
                      className="w-8 h-8 rounded border border-gray-300 hover:bg-gray-50 disabled:opacity-50 flex items-center justify-center"
                    >
                      +
                    </button>
                  </div>
                </div>
                
                <div className="text-right">
                  <div className="text-sm text-gray-500">€{item.unit_price} each</div>
                  <div className="text-lg font-semibold text-gray-900">€{item.total_price}</div>
                </div>
              </div>
            </div>
          ))}

          {/* Cart Summary */}
          <div className="bg-gray-50 border rounded-lg p-6">
            <div className="flex justify-between items-center mb-4">
              <span className="text-lg font-semibold">Total:</span>
              <span className="text-2xl font-bold text-green-600">
                €{cartData.total_price}
              </span>
            </div>
            
            <div className="space-y-3">
              <button className="w-full bg-green-600 hover:bg-green-700 text-white py-3 rounded-lg font-semibold transition-colors">
                Proceed to Checkout
              </button>
              
              <Link 
                href="/"
                className="block w-full bg-gray-600 hover:bg-gray-700 text-white py-3 rounded-lg font-semibold text-center transition-colors"
              >
                Continue Shopping
              </Link>
            </div>
          </div>
        </div>
      ) : (
        <div className="text-center py-16">
          <div className="text-6xl mb-4">🛒</div>
          <h2 className="text-xl font-semibold mb-4 text-gray-900">Your cart is empty</h2>
          <p className="text-gray-600 mb-8">Start by browsing our products and customizing your perfect bike!</p>
          <Link 
            href="/"
            className="inline-block bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg font-semibold transition-colors"
          >
            Browse Products
          </Link>
        </div>
      )}
    </div>
  );
};

export default Cart;
