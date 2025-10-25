import { useState } from 'react';
import Header from './components/Header';
import InputSection from './components/InputSection';
import ActionButton from './components/ActionButton';
import ResultDisplay from './components/ResultDisplay';
import { getRandomDish } from './services/api';
import './App.css';

function App() {
  const [inputText, setInputText] = useState('');
  const [dishResult, setDishResult] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [showResult, setShowResult] = useState(false);

  const handleGetDish = async () => {
    setLoading(true);
    setError(null);
    setShowResult(false);

    try {
      const dish = await getRandomDish();
      setDishResult(dish);
      setShowResult(true);
    } catch (err) {
      setError(err.message);
      setShowResult(true);
    } finally {
      setLoading(false);
    }
  };

  const handleInputChange = (e) => {
    setInputText(e.target.value);
  };

  return (
    <div className="app">
      <Header />
      <div className="main-content">
        <InputSection value={inputText} onChange={handleInputChange} />
        <ActionButton onClick={handleGetDish} loading={loading} />
        <ResultDisplay result={dishResult} visible={showResult} error={error} />
      </div>
    </div>
  );
}

export default App;
