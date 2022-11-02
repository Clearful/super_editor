import 'package:flutter_test/flutter_test.dart';
import 'package:super_editor/super_editor.dart';

import 'test_documents.dart';

void main() {
  group("MutableDocument", () {
    test("calculates a range from an upstream selection within a single node", () {
      final document = MutableDocument(
        nodes: [
          ParagraphNode(
            id: "1",
            text: AttributedText(text: "This is a paragraph of text."),
          ),
        ],
      );

      // Try to get an upstream range.
      final range = document.getRangeBetween(
        const DocumentPosition(nodeId: "1", nodePosition: TextNodePosition(offset: 20)),
        const DocumentPosition(nodeId: "1", nodePosition: TextNodePosition(offset: 10)),
      );

      // Ensure the range is upstream.
      expect(
        range.start,
        const DocumentPosition(
          nodeId: "1",
          nodePosition: TextNodePosition(offset: 10),
        ),
      );
      expect(
        range.end,
        const DocumentPosition(
          nodeId: "1",
          nodePosition: TextNodePosition(offset: 20),
        ),
      );
    });

    test("calculates a range from an downstream selection within a single node", () {
      final document = MutableDocument(
        nodes: [
          ParagraphNode(
            id: "1",
            text: AttributedText(text: "This is a paragraph of text."),
          ),
        ],
      );

      // Try to get an upstream range.
      final range = document.getRangeBetween(
        const DocumentPosition(nodeId: "1", nodePosition: TextNodePosition(offset: 10)),
        const DocumentPosition(nodeId: "1", nodePosition: TextNodePosition(offset: 20)),
      );

      // Ensure the range is upstream.
      expect(
        range.start,
        const DocumentPosition(
          nodeId: "1",
          nodePosition: TextNodePosition(offset: 10),
        ),
      );
      expect(
        range.end,
        const DocumentPosition(
          nodeId: "1",
          nodePosition: TextNodePosition(offset: 20),
        ),
      );
    });

    group("getNodeIndexById returns the correct index", () {
      test("when creating a document", () {
        final document = _createThreeParagraphDoc();
        final firstNode = document.nodes[0];
        final secondNode = document.nodes[1];
        final thirdNode = document.nodes[2];

        // Ensure the indices are correct when creating the document.
        expect(document.getNodeIndexById(firstNode.id), 0);
        expect(document.getNodeIndexById(secondNode.id), 1);
        expect(document.getNodeIndexById(thirdNode.id), 2);
      });

      test("when inserting a node at the beginning by index", () {
        final document = _createTwoParagraphDoc();
        final firstNode = document.nodes[0];
        final secondNode = document.nodes[1];

        // Insert a new node at the beginning.
        final thirdNode = ParagraphNode(
          id: "3",
          text: AttributedText(text: "This is the third paragraph."),
        );
        document.insertNodeAt(0, thirdNode);

        // Ensure the indices are correct.
        expect(document.getNodeIndexById(thirdNode.id), 0);
        expect(document.getNodeIndexById(firstNode.id), 1);
        expect(document.getNodeIndexById(secondNode.id), 2);
      });

      test("when inserting a node at the middle by index", () {
        final document = _createTwoParagraphDoc();
        final firstNode = document.nodes[0];
        final secondNode = document.nodes[1];

        // Insert a new node between firstNode and secondNode.
        final thirdNode = ParagraphNode(
          id: "3",
          text: AttributedText(text: "This is the third paragraph."),
        );
        document.insertNodeAt(1, thirdNode);

        // Ensure the indices are correct.
        expect(document.getNodeIndexById(firstNode.id), 0);
        expect(document.getNodeIndexById(thirdNode.id), 1);
        expect(document.getNodeIndexById(secondNode.id), 2);
      });

      test("when inserting a node at the end by index", () {
        final document = _createTwoParagraphDoc();
        final firstNode = document.nodes[0];
        final secondNode = document.nodes[1];

        // Insert a new node at the end.
        final thirdNode = ParagraphNode(
          id: "3",
          text: AttributedText(text: "This is the third paragraph."),
        );
        document.insertNodeAt(2, thirdNode);

        // Ensure the indices are correct.
        expect(document.getNodeIndexById(firstNode.id), 0);
        expect(document.getNodeIndexById(secondNode.id), 1);
        expect(document.getNodeIndexById(thirdNode.id), 2);
      });

      test("when inserting a node before the first node", () {
        final document = _createTwoParagraphDoc();
        final firstNode = document.nodes[0];
        final secondNode = document.nodes[1];

        // Insert a new node at the beginning.
        final thirdNode = ParagraphNode(
          id: "3",
          text: AttributedText(text: "This is the third paragraph."),
        );
        document.insertNodeBefore(
          existingNode: firstNode,
          newNode: thirdNode,
        );

        // Ensure the indices are correct.
        expect(document.getNodeIndexById(thirdNode.id), 0);
        expect(document.getNodeIndexById(firstNode.id), 1);
        expect(document.getNodeIndexById(secondNode.id), 2);
      });

      test("when inserting a node before the last node", () {
        final document = _createTwoParagraphDoc();
        final firstNode = document.nodes[0];
        final secondNode = document.nodes[1];

        // Insert a new node between the two nodes.
        final thirdNode = ParagraphNode(
          id: "3",
          text: AttributedText(text: "This is the third paragraph."),
        );
        document.insertNodeBefore(
          existingNode: secondNode,
          newNode: thirdNode,
        );

        // Ensure the indices are correct.
        expect(document.getNodeIndexById(firstNode.id), 0);
        expect(document.getNodeIndexById(thirdNode.id), 1);
        expect(document.getNodeIndexById(secondNode.id), 2);
      });

      test("when inserting a node after the first node", () {
        final document = _createTwoParagraphDoc();
        final firstNode = document.nodes[0];
        final secondNode = document.nodes[1];

        // Insert a new node between the two nodes.
        final thirdNode = ParagraphNode(
          id: "3",
          text: AttributedText(text: "This is the third paragraph."),
        );
        document.insertNodeAfter(
          existingNode: firstNode,
          newNode: thirdNode,
        );

        // Ensure the indices are correct.
        expect(document.getNodeIndexById(firstNode.id), 0);
        expect(document.getNodeIndexById(thirdNode.id), 1);
        expect(document.getNodeIndexById(secondNode.id), 2);
      });

      test("when inserting a node after the last node", () {
        final document = _createTwoParagraphDoc();
        final firstNode = document.nodes[0];
        final secondNode = document.nodes[1];

        // Insert a new node at the end.
        final thirdNode = ParagraphNode(
          id: "3",
          text: AttributedText(text: "This is the third paragraph."),
        );
        document.insertNodeAfter(
          existingNode: secondNode,
          newNode: thirdNode,
        );

        // Ensure the indices are correct.
        expect(document.getNodeIndexById(firstNode.id), 0);
        expect(document.getNodeIndexById(secondNode.id), 1);
        expect(document.getNodeIndexById(thirdNode.id), 2);
      });

      test("when moving a node from the beginning to the middle", () {
        final document = _createThreeParagraphDoc();
        final firstNode = document.nodes[0];
        final secondNode = document.nodes[1];
        final thirdNode = document.nodes[2];

        document.moveNode(
          nodeId: firstNode.id,
          targetIndex: 1,
        );

        // Ensure the indices are correct.
        expect(document.getNodeIndexById(secondNode.id), 0);
        expect(document.getNodeIndexById(firstNode.id), 1);
        expect(document.getNodeIndexById(thirdNode.id), 2);
      });

      test("when moving a node from the middle to the end", () {
        final document = _createThreeParagraphDoc();
        final firstNode = document.nodes[0];
        final secondNode = document.nodes[1];
        final thirdNode = document.nodes[2];

        document.moveNode(
          nodeId: secondNode.id,
          targetIndex: 2,
        );

        // Ensure the indices are correct.
        expect(document.getNodeIndexById(firstNode.id), 0);
        expect(document.getNodeIndexById(thirdNode.id), 1);
        expect(document.getNodeIndexById(secondNode.id), 2);
      });

      test("when moving a node from the end to the middle", () {
        final document = _createThreeParagraphDoc();
        final firstNode = document.nodes[0];
        final secondNode = document.nodes[1];
        final thirdNode = document.nodes[2];

        document.moveNode(
          nodeId: thirdNode.id,
          targetIndex: 1,
        );

        // Ensure the indices are correct.
        expect(document.getNodeIndexById(firstNode.id), 0);
        expect(document.getNodeIndexById(thirdNode.id), 1);
        expect(document.getNodeIndexById(secondNode.id), 2);
      });

      test("when moving a node from the middle to the beginning", () {
        final document = _createThreeParagraphDoc();
        final firstNode = document.nodes[0];
        final secondNode = document.nodes[1];
        final thirdNode = document.nodes[2];

        document.moveNode(
          nodeId: secondNode.id,
          targetIndex: 0,
        );

        // Ensure the indices are correct.
        expect(document.getNodeIndexById(secondNode.id), 0);
        expect(document.getNodeIndexById(firstNode.id), 1);
        expect(document.getNodeIndexById(thirdNode.id), 2);
      });

      test("when deleting a node at the beginning", () {
        final document = _createThreeParagraphDoc();
        final firstNode = document.nodes[0];
        final secondNode = document.nodes[1];
        final thirdNode = document.nodes[2];

        document.deleteNode(firstNode);

        // Ensure the indices are correct.
        expect(document.getNodeIndexById(firstNode.id), -1);
        expect(document.getNodeIndexById(secondNode.id), 0);
        expect(document.getNodeIndexById(thirdNode.id), 1);
      });

      test("when deleting a node at the middle", () {
        final document = _createThreeParagraphDoc();
        final firstNode = document.nodes[0];
        final secondNode = document.nodes[1];
        final thirdNode = document.nodes[2];

        document.deleteNode(secondNode);

        // Ensure the indices are correct.
        expect(document.getNodeIndexById(secondNode.id), -1);
        expect(document.getNodeIndexById(firstNode.id), 0);
        expect(document.getNodeIndexById(thirdNode.id), 1);
      });

      test("when deleting a node at the end", () {
        final document = _createThreeParagraphDoc();
        final firstNode = document.nodes[0];
        final secondNode = document.nodes[1];
        final thirdNode = document.nodes[2];

        document.deleteNode(thirdNode);

        // Ensure the indices are correct.
        expect(document.getNodeIndexById(thirdNode.id), -1);
        expect(document.getNodeIndexById(firstNode.id), 0);
        expect(document.getNodeIndexById(secondNode.id), 1);
      });

      test("when replacing a node at the beginning", () {
        final document = _createThreeParagraphDoc();
        final firstNode = document.nodes[0];
        final secondNode = document.nodes[1];
        final thirdNode = document.nodes[2];

        final fourthNode = ParagraphNode(
          id: "4",
          text: AttributedText(text: "This is the third paragraph."),
        );

        document.replaceNode(
          oldNode: firstNode,
          newNode: fourthNode,
        );

        // Ensure the indices are correct.
        expect(document.getNodeIndexById(firstNode.id), -1);
        expect(document.getNodeIndexById(fourthNode.id), 0);
        expect(document.getNodeIndexById(secondNode.id), 1);
        expect(document.getNodeIndexById(thirdNode.id), 2);
      });

      test("when replacing a node at the middle", () {
        final document = _createThreeParagraphDoc();
        final firstNode = document.nodes[0];
        final secondNode = document.nodes[1];
        final thirdNode = document.nodes[2];

        final fourthNode = ParagraphNode(
          id: "4",
          text: AttributedText(text: "This is the third paragraph."),
        );

        document.replaceNode(
          oldNode: secondNode,
          newNode: fourthNode,
        );

        // Ensure the indices are correct.
        expect(document.getNodeIndexById(secondNode.id), -1);
        expect(document.getNodeIndexById(firstNode.id), 0);
        expect(document.getNodeIndexById(fourthNode.id), 1);
        expect(document.getNodeIndexById(thirdNode.id), 2);
      });

      test("when replacing a node at the end", () {
        final document = _createThreeParagraphDoc();
        final firstNode = document.nodes[0];
        final secondNode = document.nodes[1];
        final thirdNode = document.nodes[2];

        final fourthNode = ParagraphNode(
          id: "4",
          text: AttributedText(text: "This is the third paragraph."),
        );

        document.replaceNode(
          oldNode: thirdNode,
          newNode: fourthNode,
        );

        // Ensure the indices are correct.
        expect(document.getNodeIndexById(thirdNode.id), -1);
        expect(document.getNodeIndexById(firstNode.id), 0);
        expect(document.getNodeIndexById(secondNode.id), 1);
        expect(document.getNodeIndexById(fourthNode.id), 2);
      });
    });
  });
}

MutableDocument _createTwoParagraphDoc() {
  return MutableDocument(
    nodes: [
      ParagraphNode(
        id: "1",
        text: AttributedText(text: "This is the first paragraph."),
      ),
      ParagraphNode(
        id: "2",
        text: AttributedText(text: "This is the second paragraph."),
      ),
    ],
  );
}

MutableDocument _createThreeParagraphDoc() {
  return MutableDocument(
    nodes: [
      ParagraphNode(
        id: "1",
        text: AttributedText(text: "This is the first paragraph."),
      ),
      ParagraphNode(
        id: "2",
        text: AttributedText(text: "This is the second paragraph."),
      ),
      ParagraphNode(
        id: "3",
        text: AttributedText(text: "This is the third paragraph."),
      ),
    ],
  );
}
