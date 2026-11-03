// lib/models/data_sources/xmlforge_database.dart
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

class XmlForgeDatabase {
  static final XmlForgeDatabase instance = XmlForgeDatabase._init();

  Socket? _socket;
  String? _sessionToken;
  final List<int> _buffer = [];
  Timer? _keepAliveTimer;

  // ==========================================
  // CONFIGURATION DE LA CONNECTIVITÉ SGBD
  // ==========================================

  // ⚠️ À REMPLIR : L'adresse IP du serveur XMLForge ('127.0.0.1' ou 'localhost' si sur la même machine)
  final String _host = '127.0.0.1';

  // ⚠️ À REMPLIR : Le port TCP d'écoute (Par défaut 3307 pour XMLForge)
  final int _port = 3307;

  XmlForgeDatabase._init();

  String? get sessionToken => _sessionToken;

  // ==========================================
  // APPLICATION DES IDENTIFIANTS TCP
  // ==========================================
  Future<void> connect() async {
    if (_socket != null) return;

    try {
      _socket = await Socket.connect(_host, _port, timeout: const Duration(seconds: 10));

      _socket!.listen(
        _onDataReceived,
        onError: (error) => disconnect(),
        onDone: () => disconnect(),
      );

      final Map<String, dynamic> authPayload = {
        // ⚠️ À REMPLIR : L'identifiant TCP généré dans les paramètres de XMLForge
        'username': 'thefireviolet@gmail.com',

        // ⚠️ À REMPLIR : Le mot de passe associé à cet identifiant TCP
        'password': 'e8qhApUL4oF7GssohCVeww',

        // ⚠️ À REMPLIR : Le nom exact de la base de données créée sur l'interface (Ex: 'Commerce')
        'database': 'tourGabon_db',
      };

      final response = await sendFrame(1, authPayload);

      if (response['status'] == 0 && response.containsKey('session_token')) {
        _sessionToken = response['session_token'] as String;
        _startKeepAliveTimer();
        print("XMLForge : Connexion et authentification réussies.");
      } else {
        await disconnect();
        throw Exception("Échec de l'authentification XMLForge. Vérifiez vos identifiants TCP.");
      }
    } catch (e) {
      await disconnect();
      throw Exception("Impossible de se connecter à XMLForge: $e");
    }
  }

  void _startKeepAliveTimer() {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = Timer.periodic(const Duration(minutes: 25), (timer) async {
      if (_socket != null) {
        try {
          final String jsonString = jsonEncode({});
          final List<int> bodyBytes = utf8.encode(jsonString);

          final Uint8List header = Uint8List(5);
          header[0] = 5; // Type 5 : MSG_PING

          final ByteData lengthData = ByteData(4);
          lengthData.setUint32(0, bodyBytes.length, Endian.big);
          header.setRange(1, 5, lengthData.buffer.asUint8List());

          _socket!.add(header);
          _socket!.add(bodyBytes);
          await _socket!.flush();
        } catch (e) {
          disconnect();
        }
      }
    });
  }

  Future<Map<String, dynamic>> sendFrame(int messageType, Map<String, dynamic> payload) async {
    if (_socket == null) throw Exception("Aucune connexion TCP active.");

    final String jsonString = jsonEncode(payload);
    final List<int> bodyBytes = utf8.encode(jsonString);

    final Uint8List header = Uint8List(5);
    header[0] = messageType;

    final ByteData lengthData = ByteData(4);
    lengthData.setUint32(0, bodyBytes.length, Endian.big);
    header.setRange(1, 5, lengthData.buffer.asUint8List());

    _socket!.add(header);
    _socket!.add(bodyBytes);
    await _socket!.flush();

    return await _attendreReponse();
  }

  void _onDataReceived(List<int> chunk) {
    _buffer.addAll(chunk);
    if (_buffer.length >= 5 && _buffer[0] == 6) {
      final bd = ByteData.sublistView(Uint8List.fromList(_buffer), 1, 5);
      final int size = bd.getUint32(0, Endian.big);
      if (_buffer.length >= 5 + size) {
        _buffer.removeRange(0, 5 + size);
      }
    }
  }

  Future<Map<String, dynamic>> _attendreReponse() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_buffer.length >= 5) {
      final bd = ByteData.sublistView(Uint8List.fromList(_buffer), 1, 5);
      final int size = bd.getUint32(0, Endian.big);

      if (_buffer.length >= 5 + size) {
        final bodyBytes = _buffer.sublist(5, 5 + size);
        _buffer.removeRange(0, 5 + size);
        final String jsonStr = utf8.decode(bodyBytes);
        return jsonDecode(jsonStr) as Map<String, dynamic>;
      }
    }
    return {'status': -1, 'message': 'Erreur de lecture du protocole'};
  }

  Future<void> disconnect() async {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;

    if (_sessionToken != null && _socket != null) {
      try {
        await sendFrame(9, {'session_token': _sessionToken});
      } catch (_) {}
    }
    _sessionToken = null;
    await _socket?.close();
    _socket = null;
    _buffer.clear();
    print("XMLForge : Connexion TCP fermée.");
  }
}
