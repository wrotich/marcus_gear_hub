'use client';
import { useState, useEffect } from 'react';

const CartBadge = () => {
  const [itemCount, setItemCount] = useState(0);

  useEffect(() => {
    const fetchCartCount = async () => {
      try {
        const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/v1/cart_items`, { credentials: 'include' });
        const data = await response.json();
        setItemCount(data.cart?.item_count || 0);
      } catch (error) {
        setItemCount(0);
      }
    };
    fetchCartCount();
  }, []);

  if (itemCount <= 0) return null;

  return (
    <span className="ml-1 inline-flex items-center justify-center px-2 py-1 text-xs font-bold leading-none text-white bg-blue-600 rounded-full">
      {itemCount}
    </span>
  );
};

export default CartBadge;
