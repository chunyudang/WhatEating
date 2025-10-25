import './InputSection.css';

function InputSection({ value, onChange }) {
  return (
    <div className="input-section">
      <input
        type="text"
        className="input-field"
        placeholder="想吃点什么？（可选）"
        value={value}
        onChange={onChange}
      />
    </div>
  );
}

export default InputSection;
