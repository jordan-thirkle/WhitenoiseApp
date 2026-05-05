import React, { useState, useEffect } from 'react';
import { Heart, Share2, MessageSquare, Eye } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { showToast } from '@/store';

interface Props {
  title?: string;
  url?: string;
  path?: string;
  initialLikes?: number;
  initialViews?: number;
  showComments?: boolean;
}

export const EngagementDock: React.FC<Props> = ({ title = '', url = '', path = '', initialLikes = 0, initialViews = 0, showComments = true }) => {
  const [likes, setLikes] = useState(initialLikes);
  const [views, setViews] = useState(initialViews);
  const [hasLiked, setHasLiked] = useState(false);
  const [isShareOpen, setIsShareOpen] = useState(false);

  useEffect(() => {
    if (!path) return;

    // Setup LocalStorage Keys
    const likedKey = `hub-liked-${path}`;
    const likesKey = `hub-total-likes-${path}`;
    const viewsKey = `hub-views-${path}`;

    // Handle Likes
    const liked = localStorage.getItem(likedKey) === 'true';
    const storedLikes = localStorage.getItem(likesKey);
    setHasLiked(liked);
    if (storedLikes) {
        setLikes(parseInt(storedLikes, 10));
    } else {
        localStorage.setItem(likesKey, initialLikes.toString());
        setLikes(initialLikes);
    }

    // Handle Views (increment on load)
    const storedViews = localStorage.getItem(viewsKey);
    const newViews = storedViews ? parseInt(storedViews, 10) + 1 : initialViews + 1;
    setViews(newViews);
    localStorage.setItem(viewsKey, newViews.toString());
  }, [path, initialLikes, initialViews]);

  const handleLike = () => {
    if (!path) return;
    const likedKey = `hub-liked-${path}`;
    const likesKey = `hub-total-likes-${path}`;

    if (hasLiked) {
      setHasLiked(false);
      setLikes(prev => {
        const newLikes = prev - 1;
        localStorage.setItem(likesKey, newLikes.toString());
        return newLikes;
      });
      localStorage.setItem(likedKey, 'false');
    } else {
      setHasLiked(true);
      setLikes(prev => {
        const newLikes = prev + 1;
        localStorage.setItem(likesKey, newLikes.toString());
        return newLikes;
      });
      localStorage.setItem(likedKey, 'true');
      showToast('Thanks for the support!', 'success');
    }
  };

  const handleShare = () => {
    setIsShareOpen(!isShareOpen);
  };

  const tweetText = `Just posted: ${title} 🏗️\n\nBy @jordan_Thirkle #BuildInPublic #AI #Engineering`;
  const [currentUrl, setCurrentUrl] = useState(url);

  useEffect(() => {
    if (!url && typeof window !== 'undefined') {
      setCurrentUrl(window.location.href);
    }
  }, [url]);

  const xShareUrl = `https://x.com/intent/post?text=${encodeURIComponent(tweetText)}&url=${encodeURIComponent(currentUrl || '')}`;

  const handleCopyThread = () => {
    const header = `${title} 🧵\n\n`;
    const intro = `I just published a new technical update on the Hub. Here is the breakdown:\n\n${currentUrl}\n\n`;
    const footer = `@jordan_Thirkle #BuildInPublic #AI #Solopreneur`;
    
    // Create a series of "tweets"
    const tweets = [
      `${header}${intro}🚀 (1/X)`,
      `Check out the full post for the architectural deep-dive and micro-wins from this sprint. 🛠️\n\n${currentUrl}\n\n${footer} (2/X)`
    ];
    
    navigator.clipboard.writeText(tweets.join('\n\n───\n\n'));
    showToast('Thread drafted & copied!', 'success');
    setIsShareOpen(false);
  };

  return (
    <div className="fixed bottom-6 left-1/2 -translate-x-1/2 z-50">
      <div className="flex items-center gap-2 p-2 bg-zinc-900/80 backdrop-blur-md border border-zinc-800 rounded-full shadow-2xl">
        <button
          onClick={handleLike}
          aria-label={hasLiked ? "Unlike" : "Like"}
          className={`flex items-center gap-2 px-4 py-2 rounded-full transition-all ${
            hasLiked 
            ? 'bg-rose-500/10 text-rose-500' 
            : 'hover:bg-zinc-800 text-zinc-400 hover:text-white'
          }`}
        >
          <Heart className={`w-4 h-4 ${hasLiked ? 'fill-current' : ''}`} />
          <span className="text-sm font-medium">{likes}</span>
        </button>

        <div className="w-[1px] h-4 bg-zinc-800 mx-1" />

        <div className="flex items-center gap-2 px-4 py-2 text-zinc-400">
          <Eye className="w-4 h-4" />
          <span className="text-sm font-medium">{views}</span>
        </div>

        {showComments && (
          <>
            <div className="w-[1px] h-4 bg-zinc-800 mx-1" />

            <a
              href="#comments"
              aria-label="Scroll to comments"
              className="p-2.5 rounded-full text-zinc-400 hover:text-white hover:bg-zinc-800 transition-all"
            >
              <MessageSquare className="w-4 h-4" />
            </a>
          </>
        )}

        <div className="w-[1px] h-4 bg-zinc-800 mx-1" />

        <div className="relative">
          <button
            onClick={handleShare}
            aria-label="Share post"
            className="p-2.5 rounded-full text-zinc-400 hover:text-white hover:bg-zinc-800 transition-all"
          >
            <Share2 className="w-4 h-4" />
          </button>

          <AnimatePresence>
            {isShareOpen && (
              <motion.div
                initial={{ opacity: 0, y: 10, scale: 0.9 }}
                animate={{ opacity: 1, y: 0, scale: 1 }}
                exit={{ opacity: 0, y: 10, scale: 0.9 }}
                className="absolute bottom-full mb-4 left-1/2 -translate-x-1/2 bg-zinc-900 border border-zinc-800 rounded-2xl p-2 shadow-2xl flex flex-col gap-1 min-w-[200px]"
              >
                <button 
                  onClick={() => {
                    navigator.clipboard.writeText(currentUrl || '');
                    showToast('Link copied!', 'success');
                    setIsShareOpen(false);
                  }}
                  className="flex items-center gap-3 px-3 py-2 rounded-lg text-sm text-zinc-300 hover:bg-zinc-800 hover:text-white transition-colors w-full text-left"
                >
                  <Share2 className="w-4 h-4" /> Copy Link
                </button>
                <a 
                  href={xShareUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  onClick={() => setIsShareOpen(false)}
                  className="flex items-center gap-3 px-3 py-2 rounded-lg text-sm text-zinc-300 hover:bg-zinc-800 hover:text-white transition-colors"
                >
                  <svg viewBox="0 0 24 24" aria-hidden="true" className="w-4 h-4 fill-current"><path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"></path></svg>
                  Share on X
                </a>
                <button 
                  onClick={handleCopyThread}
                  className="flex items-center gap-3 px-3 py-2 rounded-lg text-sm text-zinc-300 hover:bg-zinc-800 hover:text-white transition-colors w-full text-left"
                >
                  <MessageSquare className="w-4 h-4" /> Copy for X Thread
                </button>
                <a 
                  href={`https://www.linkedin.com/sharing/share-offsite/?url=${encodeURIComponent(currentUrl || '')}`}
                  target="_blank"
                  rel="noopener noreferrer"
                  onClick={() => setIsShareOpen(false)}
                  className="flex items-center gap-3 px-3 py-2 rounded-lg text-sm text-zinc-300 hover:bg-zinc-800 hover:text-white transition-colors"
                >
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" className="w-4 h-4"><path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z"/><rect width="4" height="12" x="2" y="9"/><circle cx="4" cy="4" r="2"/></svg> LinkedIn
                </a>
              </motion.div>
            )}
          </AnimatePresence>
        </div>
      </div>
    </div>
  );
};
