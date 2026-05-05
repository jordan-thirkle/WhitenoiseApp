import React from 'react';
import { useStore } from '@nanostores/react';
import { toastMessage } from '@/store';
import { CheckCircle, AlertCircle, Info, X } from 'lucide-react';
import { AnimatePresence, motion } from 'framer-motion';

const icons = {
  success: <CheckCircle className="w-5 h-5 text-emerald-500" />,
  error: <AlertCircle className="w-5 h-5 text-rose-500" />,
  info: <Info className="w-5 h-5 text-blue-500" />,
};

export const ToastProvider: React.FC = () => {
  const $toast = useStore(toastMessage);

  return (
    <div className="fixed bottom-24 right-6 z-[100] pointer-events-none">
      <AnimatePresence>
        {$toast && (
          <motion.div
            initial={{ opacity: 0, y: 20, scale: 0.95 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, scale: 0.95 }}
            className="pointer-events-auto bg-zinc-900 border border-zinc-800 p-4 rounded-xl shadow-2xl flex items-center gap-3 min-w-[300px]"
          >
            {icons[$toast.type]}
            <p className="text-sm font-medium text-zinc-100 flex-grow">
              {$toast.message}
            </p>
            <button 
              onClick={() => toastMessage.set(null)}
              className="text-zinc-500 hover:text-zinc-300 transition-colors"
            >
              <X className="w-4 h-4" />
            </button>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};
