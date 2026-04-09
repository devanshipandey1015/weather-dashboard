import 'package:flutter/material.dart';

void main() {
  runApp(const WeatherDashboardApp());
}

class WeatherDashboardApp extends StatelessWidget {
  const WeatherDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B1220),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4DA3FF),
          brightness: Brightness.dark,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF141D2E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        ),
        useMaterial3: true,
      ),
      home: const WeatherHomePage(),
    );
  }
}

class CityWeather {
  final String city;
  final int temperature;
  final String condition;
  final int humidity;
  final int wind;
  final List<ForecastDay> forecast;

  const CityWeather({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.wind,
    required this.forecast,
  });
}

class ForecastDay {
  final String day;
  final int temp;
  final String condition;

  const ForecastDay({
    required this.day,
    required this.temp,
    required this.condition,
  });
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController(text: 'Mumbai');

  final Map<String, CityWeather> weatherData = {
    'mumbai': CityWeather(
      city: 'Mumbai',
      temperature: 31,
      condition: 'Cloudy',
      humidity: 76,
      wind: 18,
      forecast: [
        ForecastDay(day: 'Mon', temp: 31, condition: 'Cloudy'),
        ForecastDay(day: 'Tue', temp: 32, condition: 'Sunny'),
        ForecastDay(day: 'Wed', temp: 30, condition: 'Rain'),
        ForecastDay(day: 'Thu', temp: 29, condition: 'Rain'),
        ForecastDay(day: 'Fri', temp: 31, condition: 'Cloudy'),
        ForecastDay(day: 'Sat', temp: 33, condition: 'Sunny'),
        ForecastDay(day: 'Sun', temp: 32, condition: 'Sunny'),
      ],
    ),
    'delhi': CityWeather(
      city: 'Delhi',
      temperature: 28,
      condition: 'Sunny',
      humidity: 48,
      wind: 12,
      forecast: [
        ForecastDay(day: 'Mon', temp: 28, condition: 'Sunny'),
        ForecastDay(day: 'Tue', temp: 29, condition: 'Sunny'),
        ForecastDay(day: 'Wed', temp: 30, condition: 'Cloudy'),
        ForecastDay(day: 'Thu', temp: 27, condition: 'Windy'),
        ForecastDay(day: 'Fri', temp: 28, condition: 'Sunny'),
        ForecastDay(day: 'Sat', temp: 31, condition: 'Sunny'),
        ForecastDay(day: 'Sun', temp: 30, condition: 'Cloudy'),
      ],
    ),
    'bangalore': CityWeather(
      city: 'Bangalore',
      temperature: 24,
      condition: 'Rain',
      humidity: 82,
      wind: 14,
      forecast: [
        ForecastDay(day: 'Mon', temp: 24, condition: 'Rain'),
        ForecastDay(day: 'Tue', temp: 25, condition: 'Cloudy'),
        ForecastDay(day: 'Wed', temp: 24, condition: 'Rain'),
        ForecastDay(day: 'Thu', temp: 23, condition: 'Rain'),
        ForecastDay(day: 'Fri', temp: 25, condition: 'Cloudy'),
        ForecastDay(day: 'Sat', temp: 26, condition: 'Sunny'),
        ForecastDay(day: 'Sun', temp: 25, condition: 'Cloudy'),
      ],
    ),
  };

  late CityWeather selectedWeather;
  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    selectedWeather = weatherData['mumbai']!;
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void searchCity() {
    final key = _searchController.text.trim().toLowerCase();
    if (weatherData.containsKey(key)) {
      setState(() {
        selectedWeather = weatherData[key]!;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('City not found in sample data')),
      );
    }
  }

  IconData getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return Icons.wb_sunny_rounded;
      case 'rain':
        return Icons.thunderstorm_rounded;
      case 'windy':
        return Icons.air_rounded;
      default:
        return Icons.cloud_rounded;
    }
  }

  Color getWeatherColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return Colors.orange;
      case 'rain':
        return Colors.indigo;
      case 'windy':
        return Colors.teal;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final weather = selectedWeather;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Dashboard'),
        backgroundColor: const Color(0xFF0F172A),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0B1220),
              const Color(0xFF131E33),
              getWeatherColor(weather.condition).withValues(alpha: 0.22),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search city',
                          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.65)),
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.search),
                        ),
                        onSubmitted: (_) => searchCity(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: searchCity,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Search'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    getWeatherColor(weather.condition).withValues(alpha: 0.95),
                    getWeatherColor(weather.condition).withValues(alpha: 0.65),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather.city,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    weather.condition,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      AnimatedBuilder(
                        animation: _iconController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 0.9 + (_iconController.value * 0.2),
                            child: child,
                          );
                        },
                        child: Icon(
                          getWeatherIcon(weather.condition),
                          color: Colors.white,
                          size: 72,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        '${weather.temperature}°C',
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          label: 'Humidity',
                          value: '${weather.humidity}%',
                          icon: Icons.water_drop_outlined,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _InfoCard(
                          label: 'Wind',
                          value: '${weather.wind} km/h',
                          icon: Icons.air,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              '7-Day Forecast',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 165,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: weather.forecast.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final day = weather.forecast[index];
                  return Container(
                    width: 120,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF17243A),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.28),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          day.day,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Icon(
                          getWeatherIcon(day.condition),
                          size: 34,
                          color: getWeatherColor(day.condition),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${day.temp}°C',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          day.condition,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white70)),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
