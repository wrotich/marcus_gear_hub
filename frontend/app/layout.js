import './globals.css';
import Link from 'next/link';

export const metadata = {
  title: 'Marcus Sports Shop',
  description: 'Customize your perfect bicycle',
}

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className="min-h-screen">
        {/* Navigation */}
        <nav className="bg-white shadow-sm border-b border-gray-200">
          <div className="max-w-7xl mx-auto px-4">
            <div className="flex justify-between items-center h-16">
              <Link href="/" className="text-xl font-bold text-gray-900 hover:text-blue-600 transition-colors">
                Marcus Sports Shop
              </Link>
              
              <div className="flex space-x-6">
                <Link href="/" className="text-gray-600 hover:text-gray-900 transition-colors">
                  Products
                </Link>
                <Link href="/cart" className="text-gray-600 hover:text-gray-900 transition-colors">
                  Cart
                </Link>
              </div>
            </div>
          </div>
        </nav>

        {/* Main Content */}
        <main className="bg-gray-50">
          {children}
        </main>
      </body>
    </html>
  )
}
