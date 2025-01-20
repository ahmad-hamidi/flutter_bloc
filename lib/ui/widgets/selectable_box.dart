part of 'widgets.dart';

class SelectableBox extends StatelessWidget {
  final bool isSelected;
  final bool isEnabled;
  final double width;
  final double height;
  final String text;
  final VoidCallback? onTap; // Null safety for onTap
  final TextStyle? textStyle;

  const SelectableBox(
    this.text, {
    this.isSelected = false,
    this.isEnabled = true,
    this.width = 144,
    this.height = 60,
    this.onTap,
    this.textStyle,
    Key? key, // Adding key for better widget comparison
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null, // Ensure onTap only works when enabled
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: !isEnabled
              ? const Color(0xFFE4E4E4) // Disabled color
              : isSelected
                  ? accentColor2 // Selected color
                  : Colors.transparent, // Default color
          border: Border.all(
            color: !isEnabled
                ? const Color(0xFFE4E4E4) // Disabled border
                : isSelected
                    ? Colors.transparent // No border when selected
                    : const Color(0xFFE4E4E4), // Default border
          ),
        ),
        child: Center(
          child: Text(
            text.isNotEmpty ? text : "None", // Handle empty text
            style: (textStyle ?? blackTextFont).copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: isEnabled
                  ? Colors.black
                  : const Color(0xFFBEBEBE), // Adjust color when disabled
            ),
          ),
        ),
      ),
    );
  }
}
